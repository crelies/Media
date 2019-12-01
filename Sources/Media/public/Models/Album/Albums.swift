//
//  Albums.swift
//  Media
//
//  Created by Christian Elies on 22.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
public struct Albums {
    public static var all: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    public static var user: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { collection in
            if AlbumType.user.subtypes.contains(collection.assetCollectionSubtype) {
                return true
            }
            return false
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    public static var smart: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .smartAlbum, subtype: .any, options: options) { collection in
            if AlbumType.smart.subtypes.contains(collection.assetCollectionSubtype) {
                return true
            }
            return false
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    public static var cloud: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { collection in
            if AlbumType.cloud.subtypes.contains(collection.assetCollectionSubtype) {
                return true
            }
            return false
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }
}
