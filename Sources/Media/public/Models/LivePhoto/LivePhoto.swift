//
//  LivePhoto.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

@available(iOS 9, OSX 10.11, *)
public struct LivePhoto: AbstractMedia {
    public let phAsset: PHAsset

    public let type: MediaType = .image
    public var subtype: MediaSubtype { .photoLive }
    public var isFavorite: Bool { phAsset.isFavorite }

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

@available(iOS 9, *)
public extension LivePhoto {
    func displayRepresentation(targetSize: CGSize,
                               contentMode: PHImageContentMode = .default,
                               _ completion: @escaping (Result<LivePhoto.DisplayRepresentation, Error>) -> Void) {
        let options = PHLivePhotoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestLivePhoto(for: phAsset,
                                                  targetSize: targetSize,
                                                  contentMode: contentMode,
                                                  options: options)
        { livePhoto, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let livePhoto = livePhoto {
                let imageResultIsDegraded = info?[PHImageResultIsDegradedKey] as? NSNumber
                switch imageResultIsDegraded?.boolValue {
                    case .none:
                        let displayRepresentation = LivePhoto.DisplayRepresentation(quality: .high, livePhoto: livePhoto)
                        completion(.success(displayRepresentation))
                    case .some(let booleanValue):
                        if booleanValue {
                            let displayRepresentation = LivePhoto.DisplayRepresentation(quality: .low, livePhoto: livePhoto)
                            completion(.success(displayRepresentation))
                        } else {
                            let displayRepresentation = LivePhoto.DisplayRepresentation(quality: .high, livePhoto: livePhoto)
                            completion(.success(displayRepresentation))
                        }
                }
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }
}

@available(iOS 9, OSX 10.11, *)
public extension LivePhoto {
    // TODO: determine file type
    static func save(_ url: URL, _ completion: @escaping (Result<LivePhoto, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        var placeholderForCreatedAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
            if let placeholder = creationRequest?.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let livePhoto = Self.with(identifier: localIdentifier) {
                    completion(.success(livePhoto))
                } else {
                    completion(.failure(PhotosError.unknown))
                }
            }
        })
    }

    static func with(identifier: String) -> LivePhoto? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d && (mediaSubtypes & %d) != 0", identifier, MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        let livePhoto = PHAssetFetcher.fetchAsset(LivePhoto.self, options: options) { asset in
            if asset.localIdentifier == identifier && asset.mediaType == .image && asset.mediaSubtypes.contains(.photoLive) {
                return true
            }
            return false
        }
        return livePhoto
    }
}

@available(iOS 9, OSX 10.11, *)
public extension LivePhoto {
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

@available(iOS 13, *)
public extension LivePhoto {
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw CameraError.noCameraAvailable
        }

        return MediaPicker(sourceType: .camera, mediaTypes: [.image, .livePhoto]) { value in
            guard case let MediaPickerValue.tookLivePhoto(imageURL) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(imageURL))
        }
    }

    func view(size: CGSize) -> some View {
        LivePhotoView(livePhoto: self, size: size)
    }
}

@available (iOS 13, OSX 10.15, *)
public extension LivePhoto {
    static func browser(_ completion: @escaping (Result<LivePhoto, Error>) -> Void) throws -> some View {
        var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            sourceType = .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            sourceType = .savedPhotosAlbum
        } else {
            throw MediaPickerError.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: [.image, .livePhoto]) { value in
            guard case let MediaPickerValue.selectedLivePhoto(livePhoto) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(livePhoto))
        }
    }
}
#endif
