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

    init(phAssetCollection: PHAssetCollection) {
        self.phAssetCollection = phAssetCollection
    }
}

public extension Album {
    var audios: [Audio] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = predicate

        let audios = PHAssetFetcher.fetchAssets(in: phAssetCollection, options: options) as [Audio]
        return audios
    }

    var photos: [Photo] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        if #available(iOS 9.1, *) {
            let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) == 0", MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
            options.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "mediaType = %d", MediaType.image.rawValue)
            options.predicate = predicate
        }

        let photos = PHAssetFetcher.fetchAssets(in: phAssetCollection, options: options) as [Photo]
        return photos
    }

    var videos: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.video.rawValue)
        options.predicate = predicate

        let videos = PHAssetFetcher.fetchAssets(in: phAssetCollection, options: options) as [Video]
        return videos
    }

    var livePhotos: [LivePhoto] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        let livePhotos = PHAssetFetcher.fetchAssets(in: phAssetCollection, options: options) as [LivePhoto]
        return livePhotos
    }

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

public extension Album {
    static func create(title: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        guard Album.with(title: title) == nil else {
            completion(.failure(AlbumError.albumWithTitleExists))
            return
        }

        PHChanger.request({ PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title) }, completion)
    }

    func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHChanger.request({
            let assetCollections: NSArray = [self.phAssetCollection]
            PHAssetCollectionChangeRequest.deleteAssetCollections(assetCollections)
            return nil
        }, completion)
    }
}

public extension Album {
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

public extension Album {
    func add<T: MediaProtocol>(_ media: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

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

    func delete<T: MediaProtocol>(_ media: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

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
