//
//  Albums.swift
//  Media
//
//  Created by Christian Elies on 22.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Convenience type for easily fetching different
/// types of albums
///
public struct Albums {
    /// All albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(sort: [Media.Sort(key: .localizedTitle, ascending: true)])
    public static var all: [Album]

    /// All user albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(ofType: .user,
                 sort: [Media.Sort(key: .localizedTitle, ascending: true)])
    public static var user: [Album]

    /// All smart albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(ofType: .smart,
                 sort: [Media.Sort(key: .localizedTitle, ascending: true)])
    public static var smart: [Album]

    /// All cloud albums in the photo library
    /// sorted by `localizedTitle ascending`
    ///
    @FetchAlbums(ofType: .cloud,
                 sort: [Media.Sort(key: .localizedTitle, ascending: true)])
    public static var cloud: [Album]
}
