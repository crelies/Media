//
//  Videos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

public struct Videos {
    public static var all: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.video.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }

    public static var streams: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoStreamed.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }

    public static var highFrameRates: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoHighFrameRate.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }

    public static var timelapses: [Video] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.video.rawValue, MediaSubtype.videoTimelapse.rawValue)
        options.predicate = predicate
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        return videos
    }
}
