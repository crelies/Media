//
//  Audio.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Type for Audio media
///
public struct Audio: MediaProtocol {
    public typealias MediaSubtype = AudioSubtype
    public let phAsset: PHAsset
    public static let type: MediaType = .audio

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
public extension Audio {
    /// Fetches the audio with the given identifier if it exists
    ///
    /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234")])
    /// private var audio: Audio?
    ///
    /// - Parameter identifier: the `localIdentifier` of the `PHAsset`
    ///
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
