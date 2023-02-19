//
//  Audios.swift
//  MediaCore
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

/// Convenience wrapper type for fetching
/// audios
///
public struct Audios {
    /// All audios in the photo library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(sort: [Media.Sort(key: .creationDate, ascending: false)])
    public static var all: [Audio]
}
