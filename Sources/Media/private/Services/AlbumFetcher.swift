//
//  AlbumFetcher.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct AlbumFetcher {
    static func fetchAlbums(with type: PHAssetCollectionType,
                            subtype: PHAssetCollectionSubtype,
                            options: PHFetchOptions,
                            filter: @escaping (PHAssetCollection) -> Bool = { _ true }) -> [Album] {
        let result = PHAssetCollection.fetchAssetCollections(with: type,
                                                             subtype: subtype,
                                                             options: options)
        var albums: [Album] = []
        result.enumerateObjects { collection, _, _ in
            if filter(collection) {
                let album = Album(phAssetCollection: collection)
                albums.append(album)
            }
        }
        return albums
    }

    static func fetchAlbum(with type: PHAssetCollectionType,
                           subtype: PHAssetCollectionSubtype,
                           options: PHFetchOptions,
                           filter: @escaping (PHAssetCollection) -> Bool = { _ true }) -> Album? {
        let result = PHAssetCollection.fetchAssetCollections(with: type,
                                                             subtype: subtype,
                                                             options: options)
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
