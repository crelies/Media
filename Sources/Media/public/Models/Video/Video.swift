//
//  Video.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct Video: AbstractMedia {
    public let phAsset: PHAsset

    public let type: MediaType = .video
    public var isFavorite: Bool { phAsset.isFavorite }

    init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

public extension Video {
    var subtypes: [VideoSubtype] {
        var types: [VideoSubtype] = []

        switch phAsset.mediaSubtypes {
        case [.videoHighFrameRate, .videoStreamed, .videoTimelapse]:
            types.append(contentsOf: [.highFrameRate, .streamed, .timelapse])

        case [.videoHighFrameRate, .videoStreamed]:
            types.append(contentsOf: [.highFrameRate, .streamed])
        case [.videoStreamed, .videoTimelapse]:
            types.append(contentsOf: [.streamed, .timelapse])

        case [.videoHighFrameRate]:
            types.append(.highFrameRate)
        case [.videoStreamed]:
            types.append(.streamed)
        case [.videoTimelapse]:
            types.append(.timelapse)
        default: ()
        }

        return types
    }
}

public extension Video {
    func playerItem(_ completion: @escaping (Result<AVPlayerItem, Error>) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestPlayerItem(forVideo: phAsset, options: options) { playerItem, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let playerItem = playerItem {
                completion(.success(playerItem))
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }

    func avAsset(_ completion: @escaping (Result<AVAsset, Error>) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { asset, _, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let asset = asset {
                completion(.success(asset))
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }

    func export(_ exportOptions: Video.ExportOptions, progress: @escaping (Video.ExportProgress) -> Void, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestOptions = PHVideoRequestOptions()
        requestOptions.isNetworkAccessAllowed = true

        PHImageManager.default().requestExportSession(forVideo: phAsset,
                                                      options: requestOptions,
                                                      exportPreset: exportOptions.quality.avAssetExportPreset)
        { exportSession, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let exportSession = exportSession {
                exportSession.determineCompatibleFileTypes { compatibleFileTypes in
                    guard compatibleFileTypes.contains(exportOptions.fileType.avFileType) else {
                        completion(.failure(VideoError.unsupportedFileType))
                        return
                    }

                    exportSession.outputURL = exportOptions.outputURL
                    exportSession.outputFileType = exportOptions.fileType.avFileType

                    let timer = Timer(timeInterval: 1, repeats: true) { timer in
                        guard exportSession.progress < 1 else {
                            let exportProgress: ExportProgress = .completed
                            progress(exportProgress)
                            timer.invalidate()
                            return
                        }
                        let exportProgress: ExportProgress = .pending(value: exportSession.progress)
                        progress(exportProgress)
                    }
                    RunLoop.main.add(timer, forMode: .common)

                    exportSession.exportAsynchronously {
                        switch exportSession.status {
                        case .completed:
                            timer.invalidate()
                            completion(.success(()))
                        case .failed:
                            timer.invalidate()
                            completion(.failure(exportSession.error ?? PhotosError.unknown))
                        default: ()
                        }
                    }
                }
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }
}

public extension Video {
    static func with(identifier: String) -> Video? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier, MediaType.video.rawValue)
        options.predicate = predicate

        var video: Video?
        let result = PHAsset.fetchAssets(with: options)
        result.enumerateObjects { asset, _, stop in
            if asset.localIdentifier == identifier && asset.mediaType == .video {
                video = Video(phAsset: asset)
                stop.pointee = true
            }
        }
        return video
    }
}

public extension Video {
    // TODO: determine file type
    static func save(_ url: URL, _ completion: @escaping (Result<Video, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        var placeholderForCreatedAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            if let placeholder = creationRequest?.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let video = Self.with(identifier: localIdentifier) {
                    completion(.success(video))
                } else {
                    completion(.failure(PhotosError.unknown))
                }
            }
        })
    }

    // TODO:
    func edit(_ change: @escaping (inout PHContentEditingInput?) -> Void, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        let options = PHContentEditingInputRequestOptions()
        let contentEditingInputRequestID = phAsset.requestContentEditingInput(with: options) { contentEditingInput, info in
            var contentEditingInput = contentEditingInput
            change(&contentEditingInput)

            if let editingInput = contentEditingInput {
                guard Media.isAccessAllowed else {
                    completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
                    return
                }

                let output = PHContentEditingOutput(contentEditingInput: editingInput)

                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest(for: self.phAsset)
                    assetChangeRequest.contentEditingOutput = output
                }) { isSuccess, error in
                    if !isSuccess {
                        completion(.failure(error ?? PhotosError.unknown))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }

        return {
            self.phAsset.cancelContentEditingInputRequest(contentEditingInputRequestID)
        }
    }

    func favorite(_ favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest(for: self.phAsset)
            assetChangeRequest.isFavorite = favorite
        }) { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available (iOS 13, OSX 10.15, tvOS 13, *)
public extension Video {
    var view: some View {
        VideoView(video: self)
    }

    static func browser(_ completion: @escaping (Result<Video, Error>) -> Void) throws -> some View {
        var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            sourceType = .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            sourceType = .savedPhotosAlbum
        } else {
            throw MediaPickerError.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: [.movie]) { value in
            guard case let MediaPickerValue.selectedVideo(video) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(video))
        }
    }
}

@available (iOS 13, OSX 10.15, *)
public extension Video {
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw CameraError.noCameraAvailable
        }

        return MediaPicker(sourceType: .camera, mediaTypes: [.movie]) { value in
            guard case let MediaPickerValue.tookVideo(mediaURL) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(mediaURL))
        }
    }

    // TODO: UIVideoEditorController
    static func editor() -> some View {
        EmptyView()
    }
}
#endif
