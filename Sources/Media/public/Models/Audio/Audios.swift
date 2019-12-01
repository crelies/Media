//
//  Audios.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

public struct Audios {
    public static var all: [Audio] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = predicate
        let audios = PHAssetFetcher.fetchAssets(Audio.self, options: options)
        return audios
    }
}
