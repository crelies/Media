//
//  LivePhoto.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import Photos

@available(iOS 9.1, OSX 10.11, tvOS 9, *)
public struct LivePhoto: AbstractMedia {
    public let phAsset: PHAsset

    public let type: MediaType = .image
    public var subtype: MediaSubtype { .photoLive }

    init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

@available(iOS 9.1, OSX 10.11, tvOS 9, *)
public extension LivePhoto {
    func displayRepresentation(targetSize: CGSize,
                               contentMode: PHImageContentMode = .default,
                               _ completion: @escaping (Result<PHLivePhoto, Error>) -> Void) {
        let options = PHLivePhotoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestLivePhoto(for: phAsset,
                                                  targetSize: targetSize,
                                                  contentMode: contentMode,
                                                  options: options)
        { livePhoto, info in
            if let imageResultIsDegraded = info?[PHImageResultIsDegradedKey] as? NSNumber {
                if imageResultIsDegraded.boolValue {
                    return
                }
            }

            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let livePhoto = livePhoto {
                completion(.success(livePhoto))
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }
}

@available(iOS 9.1, OSX 10.11, tvOS 9, *)
public extension LivePhoto {
    static func with(identifier: String) -> LivePhoto? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d && (mediaSubtypes & %d) != 0", identifier, MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        var livePhoto: LivePhoto?
        let result = PHAsset.fetchAssets(with: options)
        result.enumerateObjects { asset, _, stop in
            if asset.localIdentifier == identifier && asset.mediaType == .image && asset.mediaSubtypes.contains(.photoLive) {
                livePhoto = LivePhoto(phAsset: asset)
                stop.pointee = true
            }
        }
        return livePhoto
    }
}

@available(iOS 9.1, OSX 10.11, tvOS 9, *)
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
}
