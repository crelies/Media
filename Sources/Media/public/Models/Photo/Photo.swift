//
//  Photo.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif
import Photos

/// Represents `Photo`s
///
public struct Photo: MediaProtocol {
    public typealias MediaSubtype = PhotoSubtype
    public let phAsset: PHAsset
    public static let type: MediaType = .image
    public var isFavorite: Bool { phAsset.isFavorite }

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

public extension Photo {
    /// Subtypes of the receiver
    /// Similar to tags, like `hdr`, `panorama` or `screenshot`
    ///
    var subtypes: [PhotoSubtype] {
        var types: [PhotoSubtype] = []

        if #available(iOS 10.2, macOS 10.11, tvOS 10.1, *) {
            switch phAsset.mediaSubtypes {
            case [.photoDepthEffect, .photoScreenshot, .photoHDR, .photoPanorama]:
                types.append(contentsOf: [.depthEffect, .screenshot, .hdr, .panorama])

            case [.photoDepthEffect, .photoScreenshot, .photoHDR]:
                types.append(contentsOf: [.depthEffect, .screenshot, .hdr])

            case [.photoDepthEffect, .photoScreenshot]:
                types.append(contentsOf: [.depthEffect, .screenshot])
            case [.photoDepthEffect, .photoHDR]:
                types.append(contentsOf: [.depthEffect, .hdr])
            case [.photoDepthEffect, .photoPanorama]:
                types.append(contentsOf: [.depthEffect, .panorama])
            case [.photoScreenshot, .photoHDR]:
                types.append(contentsOf: [.screenshot, .hdr])
            case [.photoScreenshot, .photoPanorama]:
                types.append(contentsOf: [.screenshot, .panorama])
            case [.photoHDR, .photoPanorama]:
                types.append(contentsOf: [.hdr, .panorama])

            case [.photoDepthEffect]:
                types.append(.depthEffect)
            case [.photoScreenshot]:
                types.append(.screenshot)
            case [.photoHDR]:
                types.append(.hdr)
            case [.photoPanorama]:
                types.append(.panorama)
            default: ()
            }
        } else {
            switch phAsset.mediaSubtypes {
            case [.photoScreenshot, .photoHDR, .photoPanorama]:
                types.append(contentsOf: [.screenshot, .hdr, .panorama])

            case [.photoScreenshot, .photoHDR]:
                types.append(contentsOf: [.screenshot, .hdr])
            case [.photoScreenshot, .photoPanorama]:
                types.append(contentsOf: [.screenshot, .panorama])
            case [.photoHDR, .photoPanorama]:
                types.append(contentsOf: [.hdr, .panorama])

            case [.photoScreenshot]:
                types.append(.screenshot)
            case [.photoHDR]:
                types.append(.hdr)
            case [.photoPanorama]:
                types.append(.panorama)
            default: ()
            }
        }

        return types
    }
}

#if !os(macOS)
public extension Photo {
    /// Data representation of the receiver
    ///
    /// - Parameter completion: a closure which gets a `Result` (`Data` on `success` or `Error` on `failure`)
    ///
    func data(_ completion: @escaping (Result<Data, Error>) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        if #available(iOS 13, macOS 10.15, tvOS 13, *) {
            PHImageManager.default().requestImageDataAndOrientation(for: phAsset, options: options, resultHandler: { data, _, _, info in
                PHImageManager.handleResult(result: (data, info), completion)
            })
        } else {
            // Fallback on earlier versions
            phAsset.requestContentEditingInput(with: nil) { contentEditingInput, _ in
                guard let fullSizeImageURL = contentEditingInput?.fullSizeImageURL else {
                    completion(.failure(PhotoError.missingFullSizeImageURL))
                    return
                }

                do {
                    let data = try Data(contentsOf: fullSizeImageURL)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
#endif

#if canImport(UIKit)
@available(macOS 10.15, *)
public extension Photo {
    /// `UIImage` representation of the receiver
    ///
    /// - Parameters:
    ///   - targetSize: defines the desired size (width and height)
    ///   - contentMode: specifies the desired content mode
    ///   - completion: a closure which gets a `Result` (`UIImage` on `success` or `Error` on `failure`)
    ///
    func uiImage(targetSize: CGSize,
                 contentMode: PHImageContentMode,
                 _ completion: @escaping (Result<Media.DisplayRepresentation<UIImage>, Error>) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: phAsset,
                                              targetSize: targetSize,
                                              contentMode: contentMode,
                                              options: options)
        { image, info in
            PHImageManager.handlePotentialDegradedResult((image, info), completion)
        }
    }
}
#endif

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Photo {
    /// Saves the photo media at the given `URL` if
    /// - the access to the photo library is allowed
    /// - the path extension of the URL is a valid `Photo.FileType` path extension
    ///
    /// - Parameters:
    ///   - url: the URL to the media object
    ///   - completion: a closure which gets a `Result` (`Photo` on `success` or `Error` on `failure`)
    ///
    @available(iOS 11, macOS 10.15, tvOS 11, *)
    static func save(_ url: URL, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        let supportedPathExtensions = Set(Photo.FileType.allCases.map { $0.pathExtensions }.flatMap {$0 })

        switch url.pathExtension {
        case \.isEmpty:
            completion(.failure(PhotoError.missingPathExtension))
            return
        case .unsupportedPathExtension(supportedPathExtensions: supportedPathExtensions):
            completion(.failure(PhotoError.unsupportedPathExtension))
            return
        default: ()
        }

        PHAssetChanger.createRequest({ PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url) },
                               completion)
    }

    #if canImport(UIKit)
    /// Saves the given `UIImage` if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - image: the `UIImage` which should be saved
    ///   - completion: a closure which gets a `Result` (`Photo` on `success` or `Error` on `failure`)
    ///
    static func save(_ image: UIImage, completion: @escaping (Result<Photo, Error>) -> Void) {
        PHAssetChanger.createRequest({ PHAssetChangeRequest.creationRequestForAsset(from: image) },
                                     completion)
    }
    #endif

    /// Updates the `favorite` state of the receiver
    ///
    /// - Parameters:
    ///   - favorite: a boolean indicating the new `favorite` state
    ///   - completion: a closure which gets a `Result` (`Void` on `success` or `Error` on `failure`)
    ///
    func favorite(_ favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite, completion)
    }

    /// Fetches the `Photo` with the given identifier if it exists
    ///
    /// /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234")])
    /// private var photo: Photo?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Media.Identifier<Self>) -> Photo? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier.localIdentifier, MediaType.image.rawValue)
        options.predicate = predicate

        let photo = PHAssetFetcher.fetchAsset(options: options) { asset in
            if asset.localIdentifier == identifier.localIdentifier && asset.mediaType == .image {
                return true
            }
            return false
        } as Photo?
        return photo
    }
}

public extension Photo {
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
}
