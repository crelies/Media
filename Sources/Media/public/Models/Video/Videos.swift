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
    @FetchAssets(predicate: NSPredicate(format: "mediaType = %d", MediaType.video.rawValue),
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var all: [Video]

    /// All streams in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoStreamed.rawValue),
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var streams: [Video]

    /// All high frame rate videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoHighFrameRate.rawValue),
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var highFrameRates: [Video]

    /// All timelapse videos in the library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoTimelapse.rawValue),
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var timelapses: [Video]
}
