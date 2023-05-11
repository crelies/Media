//
//  LivePhoto.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Convenience wrapper around a `PHAsset`
/// with the type `image` and subtype `photoLive`
///
public struct LivePhoto: MediaProtocol {
    public typealias ResultDisplayRepresentationCompletion = (Result<Media.DisplayRepresentation<PHLivePhotoProtocol>, Error>) -> Void

    static var livePhotoManager: LivePhotoManager = PHImageManager.default()

    private var phAsset: PHAsset? { phAssetWrapper.value }

    public typealias MediaSubtype = LivePhoto.Subtype
    public typealias MediaFileType = LivePhoto.FileType

    /// Box type for storing a reference to the
    /// underlying `PHAsset`
    /// Only used internally
    ///
    public var phAssetWrapper: PHAssetWrapper

    /// Related `PHAssetMediaType` for this live photo
    /// wrapper
    /// Used for the implementation of some
    /// generic property wrappers
    ///
    public static let type: MediaType = .image

    /// Locally available metadata of the `LivePhoto`
    public var metadata: Metadata? {
        guard let phAsset = phAsset else { return nil }
        return Metadata(
            type: phAsset.mediaType,
            subtypes: phAsset.mediaSubtypes,
            sourceType: phAsset.sourceType,
            creationDate: phAsset.creationDate,
            modificationDate: phAsset.modificationDate,
            location: phAsset.location,
            isFavorite: phAsset.isFavorite,
            isHidden: phAsset.isHidden)
    }

    /// Initializes a live photo using the given `PHAsset`
    ///
    /// - Parameter phAsset: a `PHAsset` instance with the type `image` and the subtype `photoLive`
    ///
    public init(phAsset: PHAsset) {
        phAssetWrapper = PHAssetWrapper(value: phAsset)
    }
}

extension LivePhoto: Equatable {
    public static func == (lhs: LivePhoto, rhs: LivePhoto) -> Bool {
        lhs.identifier == rhs.identifier && lhs.phAsset == rhs.phAsset
    }
}

extension LivePhoto: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(phAsset)
    }
}

#if !targetEnvironment(macCatalyst)
public extension LivePhoto {
    /// Fetches a display representation of the receiver
    ///
    /// - Parameters:
    ///   - targetSize: the desired size (width and height) of the representation
    ///   - contentMode: the content mode for the representation
    ///   - completion: a closure wich gets the `Result` (`DisplayRepresentation` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    func displayRepresentation(
        targetSize: CGSize,
        contentMode: PHImageContentMode = .default,
        _ completion: @escaping ResultDisplayRepresentationCompletion
    ) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        let options = PHLivePhotoRequestOptions()
        options.isNetworkAccessAllowed = true

        Self.livePhotoManager.customRequestLivePhoto(
            for: phAsset,
            targetSize: targetSize,
            contentMode: contentMode,
            options: options
        ) { livePhoto, info in
            PHImageManager.handlePotentialDegradedResult((livePhoto, info), completion)
        }
    }

    /// Fetches a display representation of the receiver
    ///
    /// - Parameters:
    ///   - targetSize: the desired size (width and height) of the representation
    ///   - contentMode: the content mode for the representation
    ///
    func displayRepresentation(
        targetSize: CGSize,
        contentMode: PHImageContentMode = .default
    ) async throws -> Media.DisplayRepresentation<PHLivePhotoProtocol> {
        try await withCheckedThrowingContinuation { continuation in
            self.displayRepresentation(
                targetSize: targetSize,
                contentMode: contentMode
            ) { result in
                switch result {
                case let .success(value):
                    continuation.resume(with: .success(value))
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
#endif

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 10, *)
@available(tvOS, unavailable)
public extension LivePhoto {
    /// Saves the given still image data and the movie at the given URL as a `LivePhoto`
    /// if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - data: the data object holding the image and video portion of the `LivePhoto`
    ///   - completion: a closure wich gets the `Result` (`LivePhoto` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    static func save(
        data: CapturedPhotoData,
        _ completion: @escaping ResultLivePhotoCompletion
    ) {
        PHAssetChanger.createRequest({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: data.stillImageData, options: nil)

            let options = PHAssetResourceCreationOptions()
            /*
                Use the shouldMoveFile option
                so that iOS can transfer the movie file from your app’s sandbox
                to the system Photos library without an expensive data-copying operation.
             */
            options.shouldMoveFile = true
            creationRequest.addResource(with: .pairedVideo, fileURL: data.movieURL.value, options: options)

            return creationRequest
        }, completion)
    }

    /// Saves the given still image data and the movie at the given URL as a `LivePhoto`
    /// if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - data: the data object holding the image and video portion of the `LivePhoto`
    ///
    static func save(
        data: CapturedPhotoData
    ) async throws -> LivePhoto {
        try await withCheckedThrowingContinuation { continuation in
            self.save(data: data) { result in
                switch result {
                case let .success(value):
                    continuation.resume(with: .success(value))
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

#endif

public extension LivePhoto {
    /// Fetches the `LivePhoto` with the given `identifier` if it exists
    ///
    /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234"), .mediaSubtypes([.live])])
    /// private var livePhoto: LivePhoto?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Media.Identifier<Self>) throws -> LivePhoto? {
        let options = PHFetchOptions()

        let mediaFilter: [Media.Filter<LivePhoto.Subtype>] = [.localIdentifier(identifier.localIdentifier), .mediaSubtypes([.live])]
        let mediaFilterPredicates = mediaFilter.map { $0.predicate }
        let mediaTypePredicate = NSPredicate(format: "mediaType = %d", MediaType.image.rawValue)
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate] + mediaFilterPredicates)

        let livePhoto = try PHAssetFetcher.fetchAsset(options: options) { $0.localIdentifier == identifier.localIdentifier && $0.mediaType == .image && $0.mediaSubtypes.contains(.photoLive) } as LivePhoto?
        return livePhoto
    }
}

public extension LivePhoto {
    /// Updates the favorite state of the receiver if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - favorite: a boolean which indicates the new favorite state
    ///   - completion: a closure wich gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    func favorite(
        _ favorite: Bool,
        _ completion: @escaping ResultGenericCompletion<Self>
    ) {
        guard let phAsset = phAsset else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        var livePhoto = self

        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite) { result in
            do {
                livePhoto.phAssetWrapper = .init(value: try result.get())
                completion(.success(livePhoto))
            } catch {
                completion(.failure(error))
            }
        }
    }

    /// Updates the favorite state of the receiver if the access to the photo library is allowed
    ///
    /// - Parameters:
    ///   - favorite: a boolean which indicates the new favorite state
    ///
    mutating func favorite(
        _ favorite: Bool
    ) async throws {
        guard let phAsset = phAsset else {
            throw Media.Error.noUnderlyingPHAssetFound
        }

        let updatedAsset = try await PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite)
        self.phAssetWrapper = .init(value: updatedAsset)
    }
}
