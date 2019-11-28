//
//  Audios.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Foundation
import Photos

public struct Audios {
    public static var all: [Audio] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = predicate
        let result = PHAsset.fetchAssets(with: options)

        var audios: [Audio] = []
        result.enumerateObjects { asset, _, _ in
            let audio = Audio(phAsset: asset)
            audios.append(audio)
        }
        return audios
    }
}
