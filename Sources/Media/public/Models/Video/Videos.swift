//
//  Videos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
public struct Videos {
    /// All videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.video)],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var all: [Video]

    /// All streams in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.video), .mediaSubtypes([.videoStreamed])],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var streams: [Video]

    /// All high frame rate videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.video), .mediaSubtypes([.videoHighFrameRate])],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var highFrameRates: [Video]

    /// All timelapse videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.video), .mediaSubtypes([.videoTimelapse])],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var timelapses: [Video]
}
