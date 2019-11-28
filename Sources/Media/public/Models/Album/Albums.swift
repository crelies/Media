//
//  Albums.swift
//  Media
//
//  Created by Christian Elies on 22.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import Photos

public struct Albums {
    public static var all: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let result = PHAssetCollection.fetchAssetCollections(with: .album,
                                                             subtype: .any,
                                                             options: options)
        var albums: [Album] = []
        result.enumerateObjects { collection, _, _ in
            let album = Album(phAssetCollection: collection)
            albums.append(album)
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    public static var user: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let result = PHAssetCollection.fetchAssetCollections(with: .album,
                                                             subtype: .any,
                                                             options: options)
        var albums: [Album] = []
        result.enumerateObjects { collection, _, _ in
            if AlbumType.user.subtypes.contains(collection.assetCollectionSubtype) {
                let album = Album(phAssetCollection: collection)
                albums.append(album)
            }
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    public static var smart: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                             subtype: .any,
                                                             options: options)
        var albums: [Album] = []
        result.enumerateObjects { collection, _, _ in
            if AlbumType.smart.subtypes.contains(collection.assetCollectionSubtype) {
                let album = Album(phAssetCollection: collection)
                albums.append(album)
            }
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    public static var cloud: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let result = PHAssetCollection.fetchAssetCollections(with: .album,
                                                             subtype: .any,
                                                             options: options)
        var albums: [Album] = []
        result.enumerateObjects { collection, _, _ in
            if AlbumType.cloud.subtypes.contains(collection.assetCollectionSubtype) {
                let album = Album(phAssetCollection: collection)
                albums.append(album)
            }
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }
}
