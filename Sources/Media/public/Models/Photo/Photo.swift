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
    static var assetChangeRequest: AssetChangeRequest.Type = PHAssetChangeRequest.self
    static var imageManager: ImageManager = PHImageManager.default()

    public typealias MediaSubtype = PhotoSubtype
    public typealias MediaFileType = Photo.FileType

    public let phAsset: PHAsset
    public static let type: MediaType = .image

    /// Locally available metadata of the `Photo`
    ///
    public var metadata: Metadata {
        Metadata(
            type: phAsset.mediaType,
            subtypes: phAsset.mediaSubtypes,
            sourceType: phAsset.sourceType,
            creationDate: phAsset.creationDate,
            modificationDate: phAsset.modificationDate,
            location: phAsset.location,
            isFavorite: phAsset.isFavorite,
            isHidden: phAsset.isHidden,
            pixelWidth: phAsset.pixelWidth,
            pixelHeight: phAsset.pixelHeight)
    }

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

public extension Photo {
    /// Get `EXIF`, `GPS` and `TIFF` information of the `Photo`
    /// Keep in mind that this method might download a full size copy
    /// of the `Photo` from the cloud to get the information
    ///
    /// - Parameter completion: `Result` containing a `Properties` object on `success` or an error on `failure`
    ///
    func properties(_ completion: @escaping (Result<Properties, Error>) -> Void) {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true

        phAsset.requestContentEditingInput(with: options) { contentEditingInput, _ in
            guard let fullSizeImageURL = contentEditingInput?.fullSizeImageURL else {
                completion(.failure(PhotoError.missingFullSizeImageURL))
                return
            }

            guard let fullImage = CIImage(contentsOf: fullSizeImageURL) else {
                completion(.failure(PhotoError.couldNotCreateCIImage))
                return
            }

            let properties = Properties(dictionary: fullImage.properties)
            completion(.success(properties))
        }
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
            Self.imageManager.requestImageDataAndOrientation(for: phAsset, options: options, resultHandler: { data, _, _, info in
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

        Self.imageManager.requestImage(for: phAsset,
                                       targetSize: targetSize,
                                       contentMode: contentMode,
                                       options: options)
        { image, info in
            PHImageManager.handlePotentialDegradedResult((image, info), completion)
        }
    }
}
#endif

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
    static func save(_ mediaURL: MediaURL<Self>, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        PHAssetChanger.createRequest({ assetChangeRequest.creationRequestForAssetFromImage(atFileURL: mediaURL.value) },
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
        PHAssetChanger.createRequest({ assetChangeRequest.creationRequestForAsset(from: image) },
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
    static func with(identifier: Media.Identifier<Self>) throws -> Photo? {
        let options = PHFetchOptions()
        let mediaTypeFilter: MediaFilter<PhotoSubtype> = .localIdentifier(identifier.localIdentifier)
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.image.rawValue)
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, mediaTypeFilter.predicate])

        let photo = try PHAssetFetcher.fetchAsset(options: options) { $0.localIdentifier == identifier.localIdentifier && $0.mediaType == .image } as Photo?
        return photo
    }
}
