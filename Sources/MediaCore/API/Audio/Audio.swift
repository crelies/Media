//
//  Audio.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Wrapper type for around `PHAsset`s of type `audio`
///
public struct Audio: MediaProtocol {
    public typealias MediaSubtype = Audio.Subtype
    public typealias MediaFileType = Audio.FileType

    private var phAsset: PHAsset? { phAssetWrapper.value }

    /// Box type internally used to store a reference
    /// to the underlying `PHAsset`
    public let phAssetWrapper: PHAssetWrapper

    /// `PHAssetMediaType` for the `Audio` type
    ///
    /// Used for the implementation of some generic
    /// property wrappers
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

    /// Initializes an `Audio` using the given asset
    /// - Parameter phAsset: an `PHAsset` which represents the audio
    public init(phAsset: PHAsset) {
        self.phAssetWrapper = PHAssetWrapper(value: phAsset)
    }
}

extension Audio: Equatable {
    public static func == (lhs: Audio, rhs: Audio) -> Bool {
        lhs.identifier == rhs.identifier && lhs.phAsset == rhs.phAsset
    }
}

extension Audio: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(phAsset)
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
