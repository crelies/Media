//
//  AlbumFetcher.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct AlbumFetcher {
    static var assetCollection: PHAssetCollection.Type = PHAssetCollection.self

    static func fetchAlbums(
        with type: PHAssetCollectionType,
        subtype: PHAssetCollectionSubtype,
        options: PHFetchOptions,
        filter: @escaping (PHAssetCollection) -> Bool = { _ in true }
    ) throws -> [Album] {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        let result = assetCollection.fetchAssetCollections(
            with: type,
            subtype: subtype,
            options: options
        )
        var albums: [Album] = []
        result.enumerateObjects { collection, _, _ in
            if filter(collection) {
                let album = Album(phAssetCollection: collection)
                albums.append(album)
            }
        }
        return albums
    }

    static func fetchAlbums(
        with type: PHAssetCollectionType,
        subtype: PHAssetCollectionSubtype,
        options: PHFetchOptions,
        filter: @escaping (PHAssetCollection) -> Bool = { _ in true }
    ) throws -> PHFetchResult<PHAssetCollection> {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        return assetCollection.fetchAssetCollections(
            with: type,
            subtype: subtype,
            options: options
        )
    }

    static func fetchAlbum(
        with type: PHAssetCollectionType,
        subtype: PHAssetCollectionSubtype,
        options: PHFetchOptions,
        filter: @escaping (PHAssetCollection) -> Bool = { _ in true }
    ) throws -> Album? {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        let result = assetCollection.fetchAssetCollections(
            with: type,
            subtype: subtype,
            options: options
        )
        var album: Album?
        result.enumerateObjects { collection, _, stop in
            if filter(collection) {
                album = Album(phAssetCollection: collection)
                stop.pointee = true
            }
        }
        return album
    }
}
