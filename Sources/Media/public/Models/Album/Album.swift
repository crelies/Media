//
//  Album.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct Album {
    let phAssetCollection: PHAssetCollection

    public var identifier: String { phAssetCollection.localIdentifier }
    public var localizedTitle: String? { phAssetCollection.localizedTitle }

    /// All audios contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.audio)],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public var audios: [Audio]

    /// All photos contained in the receiver (including `LivePhoto`s)
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.image), .mediaSubtypes([.photoLive])],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public var photos: [Photo]

    /// All videos contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.video)],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public var videos: [Video]

    /// All live photos contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.image), .mediaSubtypes([.photoLive])],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public var livePhotos: [LivePhoto]

    init(phAssetCollection: PHAssetCollection) {
        self.phAssetCollection = phAssetCollection
    }
}

public extension Album {
    /// All media (audios, live photos, photos, videos and more?) contained in the receiver
    /// sorted by `creationDate descending`
    ///
    var allMedia: [MediaProtocol] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(in: phAssetCollection, options: options)
        var media: [MediaProtocol] = []
        result.enumerateObjects { asset, _, _ in
            guard let mediaType = asset.abstractMediaType else {
                return
            }
            let item = mediaType.init(phAsset: asset)
            media.append(item)
        }
        return media
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Album {
    /// Creates an album with the given title
    ///
    /// - Parameters:
    ///   - title: title for the album
    ///   - completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    static func create(title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard Album.with(title: title) == nil else {
            completion(.failure(AlbumError.albumWithTitleExists))
            return
        }

        PHChanger.request({ PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title) }, completion)
    }

    /// Deletes the receiver if access to the photo library is allowed
    ///
    /// - Parameter completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        PHChanger.request({
            let assetCollections: NSArray = [self.phAssetCollection]
            PHAssetCollectionChangeRequest.deleteAssetCollections(assetCollections)
            return nil
        }, completion)
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Album {
    /// Get the album with the given `identifier` if it exists
    ///
    /// - Parameter identifier: the `localIdentifier` of the `PHAsset`
    ///
    static func with(identifier: String) -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@", identifier)
        options.predicate = predicate
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { collection in
            if collection.localIdentifier == identifier {
                return true
            }
            return false
        }
        return album
    }

    /// Get the album with the given `title` if it exists
    ///
    /// - Parameter title: the `localizedTitle` of the `PHAsset`
    ///
    static func with(title: String) -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        options.predicate = predicate
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { collection in
            if collection.localizedTitle == title {
                return true
            }
            return false
        }
        return album
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Album {
    /// Adds the given `Media`to the receiver if
    ///  - the acess to the photo library is allowed
    ///  - the receiver doesn't contain it
    ///
    /// - Parameters:
    ///   - media: an object conforming to the `MediaProtocol`
    ///   - completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    func add<T: MediaProtocol>(_ media: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !allMedia.contains(where: { $0.identifier == media.identifier }) else {
            completion(.success(()))
            return
        }

        PHChanger.request({
            let addAssetRequest = PHAssetCollectionChangeRequest(for: self.phAssetCollection)
            let assets: NSArray = [media.phAsset]
            addAssetRequest?.addAssets(assets)
            return addAssetRequest
        }, completion)
    }

    /// Deletes the given `Media` from the receiver if
    /// - the access to the photo library is allowed
    /// - the receiver contains it
    ///
    /// - Parameters:
    ///   - media: an object conforming to the `MediaProtocol`
    ///   - completion: a closure which gets the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    func delete<T: MediaProtocol>(_ media: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard allMedia.contains(where: { $0.identifier == media.identifier }) else {
            completion(.success(()))
            return
        }

        PHChanger.request({
            let assetRequest = PHAssetCollectionChangeRequest(for: self.phAssetCollection)
            let assets: NSArray = [media.phAsset]
            assetRequest?.removeAssets(assets)
            return assetRequest
        }, completion)
    }
}
