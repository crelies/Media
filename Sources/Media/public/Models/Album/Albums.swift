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
    @FetchAlbums(sortDescriptors: [NSSortDescriptor(key: "localizedTitle", ascending: true)])
    public static var all: [Album]

    /// All user albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(ofType: .user,
                 sortDescriptors: [NSSortDescriptor(key: "localizedTitle", ascending: true)])
    public static var user: [Album]
//        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }

    /// All smart albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(ofType: .smart,
                 sortDescriptors: [NSSortDescriptor(key: "localizedTitle", ascending: true)])
    public static var smart: [Album]
//        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }

    /// All cloud albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(ofType: .cloud,
                 sortDescriptors: [NSSortDescriptor(key: "localizedTitle", ascending: true)])
    public static var cloud: [Album]
//        return albums.sorted { $0.localizedTitle.compare($1.localizedTitle) == .orderedAscending }
}
