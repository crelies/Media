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
    /// All albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    public static var all: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    /// All user albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    public static var user: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { collection in
            AlbumType.user.subtypes.contains(collection.assetCollectionSubtype)
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    /// All smart albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    public static var smart: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .smartAlbum, subtype: .any, options: options) { collection in
            AlbumType.smart.subtypes.contains(collection.assetCollectionSubtype)
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }

    /// All cloud albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    public static var cloud: [Album] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { collection in
            AlbumType.cloud.subtypes.contains(collection.assetCollectionSubtype)
        }
        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
    }
}
