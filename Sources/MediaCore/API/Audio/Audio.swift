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
    public typealias MediaSubtype = Audio.Subtype
    public typealias MediaFileType = Audio.FileType

    private var phAsset: PHAsset? { phAssetWrapper.value }

    public let phAssetWrapper: PHAssetWrapper
    public static let type: MediaType = .audio

    /// Locally available metadata of the `Audio`
    public var metadata: Metadata? {
        guard let phAsset = phAsset else { return nil }
        return Metadata(
            type: phAsset.mediaType,
            subtypes: phAsset.mediaSubtypes,
            sourceType: phAsset.sourceType,
            creationDate: phAsset.creationDate,
            modificationDate: phAsset.modificationDate,
            location: phAsset.location,
            isFavorite: phAsset.isFavorite,
            isHidden: phAsset.isHidden)
    }

    public init(phAsset: PHAsset) {
        self.phAssetWrapper = PHAssetWrapper(value: phAsset)
    }
}

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
        let mediaTypeFilter: Media.Filter<Audio.Subtype> = .localIdentifier(identifier.localIdentifier)
        let predicate = NSPredicate(format: "mediaType = %d", MediaType.audio.rawValue)
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, mediaTypeFilter.predicate])

        let audio = try PHAssetFetcher.fetchAsset(options: options) { $0.localIdentifier == identifier.localIdentifier && $0.mediaType == .audio } as Audio?
        return audio
    }
}
