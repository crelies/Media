//
//  Album.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Convenience wrapper type around `PHAssetCollection`
///
public struct Album {
    let phAssetCollectionWrapper: PHAssetCollectionWrapper

    var phAssetCollection: PHAssetCollection? { phAssetCollectionWrapper.value }

    /// Identifier resolves to the local identifier of the underlying
    /// `PHAssetCollection`
    ///
    public var identifier: String? { phAssetCollection?.localIdentifier }

    /// Resolves to the `localizedTitle` of the underlying
    /// `PHAssetCollection`
    ///
    public var localizedTitle: String? { phAssetCollection?.localizedTitle }

    /// Metadata of the album
    ///
    public var metadata: Metadata? {
        guard let phAssetCollection = phAssetCollection else { return nil }
        return Metadata(phAssetCollection: phAssetCollection)
    }

    /// All audios contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets
    public var audios: [Audio]

    /// All photos contained in the receiver (including `LivePhoto`s)
    /// sorted by `creationDate descending`
    ///
    @FetchAssets
    public var photos: [Photo]

    /// All videos contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets
    public var videos: [Video]

    /// All live photos contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets
    public var livePhotos: [LivePhoto]

    /// All media (audios, live photos, photos, videos and more?) contained in the receiver
    /// sorted by `creationDate descending`.
    ///
    @FetchAllAssets
    public var allMedia: [AnyMedia]

    init(phAssetCollection: PHAssetCollection) {
        _audios = FetchAssets(in: phAssetCollection, sort: [Media.Sort(key: .creationDate, ascending: false)])
        _photos = FetchAssets(in: phAssetCollection, sort: [Media.Sort(key: .creationDate, ascending: false)])
        _videos = FetchAssets(in: phAssetCollection, sort: [Media.Sort(key: .creationDate, ascending: false)])
        _livePhotos = FetchAssets(
            in: phAssetCollection,
            filter: [.mediaSubtypes([.live])],
            sort: [Media.Sort(key: .creationDate, ascending: false)]
        )
        _allMedia = FetchAllAssets(in: phAssetCollection, sort: [Media.Sort(key: .creationDate, ascending: false)])
        phAssetCollectionWrapper = PHAssetCollectionWrapper(phAssetCollection: phAssetCollection)
    }
}

extension Album: Equatable {
    public static func == (lhs: Album, rhs: Album) -> Bool {
        lhs.identifier == rhs.identifier && lhs.phAssetCollection == rhs.phAssetCollection
    }
}

extension Album: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(phAssetCollection)
    }
}

public extension Album {
    /// Creates an album with the given title
    ///
    /// - Parameters:
    ///   - title: title for the album
    ///   - completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    static func create(
        title: String,
        completion: @escaping ResultVoidCompletion
    ) {
        do {
            guard try Album.with(localizedTitle: title) == nil else {
                completion(.failure(Album.Error.albumWithTitleExists(title)))
                return
            }
        } catch {
            completion(.failure(error))
            return
        }

        PHChanger.request({ PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title) }, completion)
    }

    /// Creates an album with the given title
    ///
    /// - Parameters:
    ///   - title: title for the album
    ///
    static func create(
        title: String
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.create(title: title) { result in
                switch result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Deletes the receiver if access to the photo library is allowed
    ///
    /// - Parameter completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    func delete(completion: @escaping ResultVoidCompletion) {
        guard let phAssetCollection = phAssetCollection else {
            completion(.failure(Media.Error.noUnderlyingPHAssetCollectionFound))
            return
        }

        PHChanger.request({
            let assetCollections: NSArray = [phAssetCollection]
            PHAssetCollectionChangeRequest.deleteAssetCollections(assetCollections)
            return nil
        }) { result in
            switch result {
            case .success:
                self.phAssetCollectionWrapper.value = nil
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Deletes the receiver if access to the photo library is allowed
    ///
    func delete() async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.delete() { result in
                switch result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public extension Album {
    /// Get the album with the given `identifier` if it exists
    ///
    /// /// Alternative:
    /// @FetchAlbum(filter: [.localIdentifier("1234")])
    /// private var album: Album?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Album.Identifier) throws -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@", identifier.localIdentifier)
        options.predicate = predicate
        let album = try AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { $0.localIdentifier == identifier.localIdentifier }
        return album
    }

    /// Get the album with the given `title` if it exists
    ///
    /// /// Alternative:
    /// @FetchAlbum(filter: [.localizedTitle("1234")])
    /// private var album: Album?
    ///
    /// - Parameter localizedTitle: the `localizedTitle` of the `PHAsset`
    ///
    static func with(localizedTitle: String) throws -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localizedTitle = %@", localizedTitle)
        options.predicate = predicate
        let album = try AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { $0.localizedTitle == localizedTitle }
        return album
    }
}

public extension Album {
    /// Adds the given `Media`to the receiver if
    ///  - the acess to the photo library is allowed
    ///  - the receiver doesn't contain it
    ///
    /// - Parameters:
    ///   - media: an object conforming to the `MediaProtocol`
    ///   - completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    func add<T: MediaProtocol>(
        _ media: T,
        completion: @escaping ResultVoidCompletion
    ) {
        guard let phAssetCollection = phAssetCollection else {
            completion(.failure(Media.Error.noUnderlyingPHAssetCollectionFound))
            return
        }

        guard let phAsset = media.phAssetWrapper.value else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        guard !allMedia.contains(where: { $0.identifier.localIdentifier == phAsset.localIdentifier }) else {
            completion(.success(()))
            return
        }

        PHChanger.request({
            let addAssetRequest = PHAssetCollectionChangeRequest(for: phAssetCollection)
            let assets: NSArray = [phAsset]
            addAssetRequest?.addAssets(assets)
            return addAssetRequest
        }, completion)
    }

    /// Adds the given `Media`to the receiver if
    ///  - the acess to the photo library is allowed
    ///  - the receiver doesn't contain it
    ///
    /// - Parameters:
    ///   - media: an object conforming to the `MediaProtocol`
    ///
    func add<T: MediaProtocol>(
        _ media: T
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.add(media) { result in
                switch result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// Deletes the given `Media` from the receiver if
    /// - the access to the photo library is allowed
    /// - the receiver contains it
    ///
    /// - Parameters:
    ///   - media: an object conforming to the `MediaProtocol`
    ///   - completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    @available(*, deprecated, message: "Use async method instead")
    func delete<T: MediaProtocol>(
        _ media: T,
        completion: @escaping ResultVoidCompletion
    ) {
        guard let phAssetCollection = phAssetCollection else {
            completion(.failure(Media.Error.noUnderlyingPHAssetCollectionFound))
            return
        }

        guard let phAsset = media.phAssetWrapper.value else {
            completion(.failure(Media.Error.noUnderlyingPHAssetFound))
            return
        }

        guard allMedia.contains(where: { $0.identifier.localIdentifier == phAsset.localIdentifier }) else {
            completion(.success(()))
            return
        }

        PHChanger.request({
            let assetRequest = PHAssetCollectionChangeRequest(for: phAssetCollection)
            let assets: NSArray = [phAsset]
            assetRequest?.removeAssets(assets)
            return assetRequest
        }, completion)
    }

    /// Deletes the given `Media` from the receiver if
    /// - the access to the photo library is allowed
    /// - the receiver contains it
    ///
    /// - Parameters:
    ///   - media: an object conforming to the `MediaProtocol`
    ///
    func delete<T: MediaProtocol>(
        _ media: T
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.delete(media) { result in
                switch result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
