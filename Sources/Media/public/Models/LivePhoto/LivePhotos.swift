//
//  LivePhotos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
public struct LivePhotos {
    /// All live photos in the photo library
    /// sorted by `creationDate descending`
    ///
    public static var all: [LivePhoto] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate

        let livePhotos = PHAssetFetcher.fetchAssets(options: options) as [LivePhoto]
        return livePhotos
    }
}
