//
//  Video.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Represents `Video`s
///
public struct Video: MediaProtocol {
    public typealias MediaSubtype = VideoSubtype
    public typealias MediaFileType = Video.FileType
    public let phAsset: PHAsset
    public static let type: MediaType = .video
    public var isFavorite: Bool { phAsset.isFavorite }

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

public extension Video {
    /// Computes the subtypes of the receiver
    /// Similar to tags, like `highFrameRate` or `timelapse`
    ///
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

@available(macOS 10.15, *)
public extension Video {
    /// Creates a `AVPlayerItem` representation of the receiver
    ///
    /// - Parameter completion: a closure which gets an `AVPlayerItem` on `success` and `Error` on `failure`
    ///
    func playerItem(_ completion: @escaping (Result<AVPlayerItem, Error>) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestPlayerItem(forVideo: phAsset, options: options) { playerItem, info in
            PHImageManager.handleResult(result: (playerItem, info), completion)
        }
    }

    /// Creates a `AVAsset` representation of the receiver
    ///
    /// - Parameter completion: a closure which gets an `AVAsset` on `success` and `Error` on `failure`
    ///
    func avAsset(_ completion: @escaping (Result<AVAsset, Error>) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: options) { asset, _, info in
            PHImageManager.handleResult(result: (asset, info), completion)
        }
    }

    /// Exports the receiver using the given options
    /// Notifies about the `progress` through the given closure
    ///
    /// - Parameters:
    ///   - exportOptions: options specifying destination, file type and quality
    ///   - progress: a closure which gets the current `Video.ExportProgress`
    ///   - completion: a closure which gets a `Void` on `success` and `Error` on `failure`
    ///
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
                // TODO: improve
                exportSession.determineCompatibleFileTypes { compatibleFileTypes in
                    guard compatibleFileTypes.contains(exportOptions.outputURL.fileType.avFileType) else {
                        completion(.failure(VideoError.unsupportedFileType))
                        return
                    }

                    exportSession.outputURL = exportOptions.outputURL.value
                    exportSession.outputFileType = exportOptions.outputURL.fileType.avFileType

                    var timer: Timer?
                    if #available(iOS 10.0, macOS 10.13, tvOS 10, *) {
                        timer = Timer(timeInterval: 1, repeats: true) { timer in
                            self.handleProgressTimerFired(exportSession: exportSession,
                                                          timer: timer,
                                                          progress: progress)
                        }
                    } else {
                        let timerWrapper = TimerWrapper(timeInterval: 1, repeats: true) { timer in
                            self.handleProgressTimerFired(exportSession: exportSession,
                                                          timer: timer,
                                                          progress: progress)
                        }
                        timer = timerWrapper.timer
                    }

                    if let timer = timer {
                        RunLoop.main.add(timer, forMode: .common)
                    }

                    exportSession.exportAsynchronously {
                        switch exportSession.status {
                        case .completed:
                            timer?.invalidate()
                            completion(.success(()))
                        case .failed:
                            timer?.invalidate()
                            completion(.failure(exportSession.error ?? MediaError.unknown))
                        default: ()
                        }
                    }
                }
            } else {
                completion(.failure(MediaError.unknown))
            }
        }
    }
}

// TODO: macOS: 10.13
@available(macOS 10.15, *)
public extension Video {
    /// Fetches the `Video` with the given identifier if it exists
    ///
    /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234")])
    /// private var video: Video?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Media.Identifier<Self>) -> Video? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier.localIdentifier, MediaType.video.rawValue)
        options.predicate = predicate

        let video = PHAssetFetcher.fetchAsset(options: options) { asset in
            if asset.localIdentifier == identifier.localIdentifier && asset.mediaType == .video {
                return true
            }
            return false
        } as Video?
        return video
    }
}

// TODO: macOS: 10.13
@available(iOS 11, *)
@available(macOS 10.15, *)
public extension Video {
    /// Saves the video media at the given URL if
    /// - the access to the photo library is allowed
    /// - the path extension of the URL matches a `Video.FileType` path extension
    ///
    /// - Parameters:
    ///   - url: URL to the media
    ///   - completion: a closure which gets `Video` on `success` and `Error` on `failure`
    ///
    static func save(_ mediaURL: MediaURL<Self>, _ completion: @escaping (Result<Video, Error>) -> Void) {
        PHAssetChanger.createRequest({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: mediaURL.value) }, completion)
    }

    // TODO:
    /*func edit(_ change: @escaping (inout PHContentEditingInput?) -> Void, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
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
    }*/

    /// Updates the `favorite` state of the receiver if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - favorite: a boolean indicating the new `favorite` state
    ///   - completion: a closure which gets `Void` on `success` and `Error` on `failure`
    ///
    func favorite(_ favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite, completion)
    }
}

extension Video {
    private func handleProgressTimerFired(exportSession: AVAssetExportSession,
                                          timer: Timer,
                                          progress: @escaping (Video.ExportProgress) -> Void) {
        guard exportSession.progress < 1 else {
            let exportProgress: ExportProgress = .completed
            progress(exportProgress)
            timer.invalidate()
            return
        }
        let exportProgress: ExportProgress = .pending(value: exportSession.progress)
        progress(exportProgress)
    }
}
