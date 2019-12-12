//
//  Album.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
public struct Album {
    let phAssetCollection: PHAssetCollection

    public var identifier: String { phAssetCollection.localIdentifier }
    public var localizedTitle: String? { phAssetCollection.localizedTitle }

    /// All audios contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(sort: [Sort(key: .creationDate, ascending: false)])
    public var audios: [Audio]

    /// All photos contained in the receiver (including `LivePhoto`s)
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(sort: [Sort(key: .creationDate, ascending: false)])
    public var photos: [Photo]

    /// All videos contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(sort: [Sort(key: .creationDate, ascending: false)])
    public var videos: [Video]

    /// All live photos contained in the receiver
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaSubtypes([.live])],
                 sort: [Sort(key: .creationDate, ascending: false)])
    public var livePhotos: [LivePhoto]

    init(phAssetCollection: PHAssetCollection) {
        self.phAssetCollection = phAssetCollection
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Album {
    /// All media (audios, live photos, photos, videos and more?) contained in the receiver
    /// sorted by `creationDate descending`
    ///
    var allMedia: [AnyMedia] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(in: phAssetCollection, options: options)
        var media: [AnyMedia] = []
        result.enumerateObjects { asset, _, _ in
            guard let anyMedia = asset.anyMedia else {
                return
            }
            media.append(anyMedia)
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
        guard Album.with(localizedTitle: title) == nil else {
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
    /// /// Alternative:
    /// @FetchAlbum(filter: [.localIdentifier("1234")])
    /// private var album: Album?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Album.Identifier) -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@", identifier.localIdentifier)
        options.predicate = predicate
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { $0.localIdentifier == identifier.localIdentifier }
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
    static func with(localizedTitle: String) -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localizedTitle = %@", localizedTitle)
        options.predicate = predicate
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { $0.localizedTitle == localizedTitle }
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
        guard !allMedia.contains(where: { $0.identifier.localIdentifier == media.identifier.localIdentifier }) else {
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
        guard allMedia.contains(where: { $0.identifier.localIdentifier == media.identifier.localIdentifier }) else {
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
