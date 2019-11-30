//
//  Audio.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct Audio: AbstractMedia {
    public let phAsset: PHAsset

    public let type: MediaType = .audio

    init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

public extension Audio {
    static func with(identifier: String) -> Audio? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier, MediaType.audio.rawValue)
        options.predicate = predicate

        var audio: Audio?
        let result = PHAsset.fetchAssets(with: options)
        result.enumerateObjects { asset, _, stop in
            if asset.localIdentifier == identifier && asset.mediaType == .audio {
                audio = Audio(phAsset: asset)
                stop.pointee = true
            }
        }
        return audio
    }
}
