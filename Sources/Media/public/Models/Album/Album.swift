//
//  Album.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import Photos
import UIKit

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
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = predicate

        let result = PHAsset.fetchAssets(in: phAssetCollection, options: options)
        var audios: [Audio] = []
        result.enumerateObjects { asset, _, _ in
            let audio = Audio(phAsset: asset)
            audios.append(audio)
        }
        return audios
    }

    var photos: [Photo] {
        let options = PHFetchOptions()
        if #available(iOS 9.1, *) {
            let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) == 0", MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
            options.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "mediaType = %d", MediaType.image.rawValue)
            options.predicate = predicate
        }

        let result = PHAsset.fetchAssets(in: phAssetCollection, options: options)
        var photos: [Photo] = []
        result.enumerateObjects { asset, _, _ in
            let photo = Photo(phAsset: asset)
            photos.append(photo)
        }
        return photos
    }

    var videos: [Video] {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.video.rawValue)
        options.predicate = predicate

        let result = PHAsset.fetchAssets(in: phAssetCollection, options: options)
        var videos: [Video] = []
        result.enumerateObjects { asset, _, _ in
            let video = Video(phAsset: asset)
            videos.append(video)
        }
        return videos
    }

    @available(iOS 9.1, OSX 10.11, tvOS 9, *)
    var livePhotos: [LivePhoto] {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        let result = PHAsset.fetchAssets(in: phAssetCollection, options: options)
        var livePhotos: [LivePhoto] = []
        result.enumerateObjects { asset, _, _ in
            let livePhoto = LivePhoto(phAsset: asset)
            livePhotos.append(livePhoto)
        }
        return livePhotos
    }

    var allMedia: [AbstractMedia] {
        let result = PHAsset.fetchAssets(in: phAssetCollection, options: nil)
        var media: [AbstractMedia] = []
        result.enumerateObjects { asset, _, _ in
            switch asset.mediaType {
            case .audio:
                let audio = Audio(phAsset: asset)
                media.append(audio)
            case .image:
                if #available(iOS 9.1, *) {
                    switch asset.mediaSubtypes {
                    case [.photoLive]:
                        let livePhoto = LivePhoto(phAsset: asset)
                        media.append(livePhoto)
                    default:
                        let photo = Photo(phAsset: asset)
                        media.append(photo)
                    }
                } else {
                    let photo = Photo(phAsset: asset)
                    media.append(photo)
                }
            case .video:
                let video = Video(phAsset: asset)
                media.append(video)
            case .unknown: ()
            @unknown default: ()
            }
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

        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        })
    }

    func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let assetCollections: NSArray = [self.phAssetCollection]
            PHAssetCollectionChangeRequest.deleteAssetCollections(assetCollections)
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        })
    }
}

public extension Album {
    static func with(identifier: String) -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@", identifier)
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album,
                                                             subtype: .any,
                                                             options: options)
        var album: Album?
        result.enumerateObjects { collection, _, stop in
            if collection.localIdentifier == identifier {
                album = Album(phAssetCollection: collection)
                stop.pointee = true
            }
        }
        return album
    }

    static func with(title: String) -> Album? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album,
                                                             subtype: .any,
                                                             options: options)
        var album: Album?
        result.enumerateObjects { collection, _, stop in
            if collection.localizedTitle == title {
                album = Album(phAssetCollection: collection)
                stop.pointee = true
            }
        }
        return album
    }
}

public extension Album {
    func add<T: AbstractMedia>(_ media: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        guard !allMedia.contains(where: { $0.identifier == media.identifier }) else {
            completion(.success(()))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let addAssetRequest = PHAssetCollectionChangeRequest(for: self.phAssetCollection)
            let assets: NSArray = [media.phAsset]
            addAssetRequest?.addAssets(assets)
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        })
    }

    func delete<T: AbstractMedia>(_ media: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        guard allMedia.contains(where: { $0.identifier == media.identifier }) else {
            completion(.success(()))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetCollectionChangeRequest(for: self.phAssetCollection)
            let assets: NSArray = [media.phAsset]
            assetRequest?.removeAssets(assets)
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        })
    }
}
