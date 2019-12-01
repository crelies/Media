//
//  LivePhoto.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct LivePhoto: MediaProtocol {
    public let phAsset: PHAsset

    public let type: MediaType = .image
    public var subtype: MediaSubtype { .photoLive }
    public var isFavorite: Bool { phAsset.isFavorite }

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

#if !os(macOS) && !targetEnvironment(macCatalyst)
public extension LivePhoto {
    func displayRepresentation(targetSize: CGSize,
                               contentMode: PHImageContentMode = .default,
                               _ completion: @escaping (Result<Media.DisplayRepresentation<PHLivePhoto>, Error>) -> Void) {
        let options = PHLivePhotoRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestLivePhoto(for: phAsset,
                                                  targetSize: targetSize,
                                                  contentMode: contentMode,
                                                  options: options)
        { livePhoto, info in
            PHImageManager.handlePotentialDegradedResult((livePhoto, info), completion)
        }
    }
}

@available(tvOS, unavailable)
public extension LivePhoto {
    // TODO: determine file type
    static func save(_ url: URL, _ completion: @escaping (Result<LivePhoto, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHAssetChanger.createRequest({ PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url) }, completion)
    }
}

#endif

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension LivePhoto {
    static func with(identifier: String) -> LivePhoto? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d && (mediaSubtypes & %d) != 0", identifier, MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        let livePhoto = PHAssetFetcher.fetchAsset(options: options) { asset in
            if asset.localIdentifier == identifier && asset.mediaType == .image && asset.mediaSubtypes.contains(.photoLive) {
                return true
            }
            return false
        } as LivePhoto?
        return livePhoto
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension LivePhoto {
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

    func favorite(_ favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite, completion)
    }
}

#if canImport(SwiftUI)
import SwiftUI

#if !os(macOS) && !os(tvOS)
@available(iOS 13, *)
public extension LivePhoto {
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        try ViewCreator.camera(for: [.image, .livePhoto], completion)
    }
}

@available(iOS 13, macOS 10.15, *)
public extension LivePhoto {
    static func browser(_ completion: @escaping (Result<LivePhoto, Error>) -> Void) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.image, .livePhoto], completion)
    }
}
#endif

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 13, tvOS 13, *)
public extension LivePhoto {
    func view(size: CGSize) -> some View {
        LivePhotoView(livePhoto: self, size: size)
    }
}
#endif

#endif
