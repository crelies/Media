//
//  LivePhoto.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Represents `LivePhoto` media
///
public struct LivePhoto: MediaProtocol {
    public typealias MediaSubtype = LivePhotoSubtype
    public let phAsset: PHAsset
    public static let type: MediaType = .image
    public var isFavorite: Bool { phAsset.isFavorite }

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

#if !os(macOS) && !targetEnvironment(macCatalyst)
public extension LivePhoto {
    /// Fetches a display representation of the receiver
    ///
    /// - Parameters:
    ///   - targetSize: the desired size (width and height) of the representation
    ///   - contentMode: the content mode for the representation
    ///   - completion: a closure wich gets the `Result` (`DisplayRepresentation` on `success` and `Error` on `failure`)
    ///
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
    /// Saves the live photo media at the given URL if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - url: the URL of the live photo media
    ///   - completion: a closure wich gets the `Result` (`LivePhoto` on `success` and `Error` on `failure`)
    ///
    static func save(_ url: URL, _ completion: @escaping (Result<LivePhoto, Error>) -> Void) {
        // TODO: determine file type
        PHAssetChanger.createRequest({ PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url) }, completion)
    }
}

#endif

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension LivePhoto {
    /// Fetches the `LivePhoto` with the given `identifier` if it exists
    ///
    /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234"), .mediaSubtypes([.live])])
    /// private var livePhoto: LivePhoto?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Media.Identifier) -> LivePhoto? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d && (mediaSubtypes & %d) != 0", identifier.localIdentifier, MediaType.image.rawValue, PHAssetMediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        let livePhoto = PHAssetFetcher.fetchAsset(options: options) { asset in
            if asset.localIdentifier == identifier.localIdentifier && asset.mediaType == .image && asset.mediaSubtypes.contains(.photoLive) {
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

    /// Updates the favorite state of the receiver if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - favorite: a boolean which indicates the new favorite state
    ///   - completion: a closure wich gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    func favorite(_ favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite, completion)
    }
}
