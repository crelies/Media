//
//  Videos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

/// Convenience wrapper type for fetching
/// different types of videos
///
public struct Videos {
    /// All videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(sort: [Media.Sort(key: .creationDate, ascending: false)])
    public static var all: [Video]

    /// All streams in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaSubtypes([.streamed])],
                 sort: [Media.Sort(key: .creationDate, ascending: false)])
    public static var streams: [Video]

    /// All high frame rate videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaSubtypes([.highFrameRate])],
                 sort: [Media.Sort(key: .creationDate, ascending: false)])
    public static var highFrameRates: [Video]

    /// All timelapse videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaSubtypes([.timelapse])],
                 sort: [Media.Sort(key: .creationDate, ascending: false)])
    public static var timelapses: [Video]
}
