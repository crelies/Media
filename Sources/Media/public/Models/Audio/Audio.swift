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
    public typealias MediaFileType = Audio.FileType
    public let phAsset: PHAsset
    public static let type: MediaType = .audio

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

@available(macOS 10.15, *)
public extension Audio {
    /// Fetches the audio with the given identifier if it exists
    ///
    /// Alternative:
    /// @FetchAsset(filter: [.localIdentifier("1234")])
    /// private var audio: Audio?
    ///
    /// - Parameter identifier: the identifier of the media
    ///
    static func with(identifier: Media.Identifier<Self>) throws -> Audio? {
        let options = PHFetchOptions()
        let mediaTypeFilter: MediaFilter<AudioSubtype> = .localIdentifier(identifier.localIdentifier)
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, mediaTypeFilter.predicate])

        let audio = try PHAssetFetcher.fetchAsset(options: options) { $0.localIdentifier == identifier.localIdentifier && $0.mediaType == .audio } as Audio?
        return audio
    }
}
