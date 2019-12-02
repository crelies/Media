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
    public static var all: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.video.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }

    /// All streams in the library
    /// sorted by `creationDate descending`
    ///
    public static var streams: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoStreamed.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }

    /// All high frame rate videos in the library
    /// sorted by `creationDate descending`
    ///
    public static var highFrameRates: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoHighFrameRate.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }

    /// All timelapse videos in the library
    /// sorted by `creationDate descending`
    ///
    public static var timelapses: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoTimelapse.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }
}
