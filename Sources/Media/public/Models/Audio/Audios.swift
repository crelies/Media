//
//  Audios.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
public struct Audios {
    public static var all: [Audio] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = predicate
        let audios = PHAssetFetcher.fetchAssets(options: options) as [Audio]
        return audios
    }
}
