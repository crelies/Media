//
//  Audio.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct Audio: MediaProtocol {
    public let phAsset: PHAsset

    public let type: MediaType = .audio

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Audio {
    static func with(identifier: String) -> Audio? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier, MediaType.audio.rawValue)
        options.predicate = predicate

        let audio = PHAssetFetcher.fetchAsset(options: options) { asset in
            if asset.localIdentifier == identifier && asset.mediaType == .audio {
                return true
            }
            return false
        } as Audio?
        return audio
    }
}
