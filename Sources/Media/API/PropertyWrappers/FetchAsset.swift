//
//  FetchAsset.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Photos

/// Property wrapper for fetching a single asset
///
@propertyWrapper
public struct FetchAsset<T: MediaProtocol> {
    private let options = PHFetchOptions().fetchLimit(1)
    private let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", T.type.rawValue)

    public var wrappedValue: T? {
        try? PHAssetFetcher.fetchAsset(options: options) { asset in
            asset.mediaType == T.type
        }
    }

    /// Initializes the property wrapper with the given predicate
    ///
    /// - Parameter filter: a set of `MediaFilter` to use for the fetch
    ///
    public init(filter: Set<Media.Filter<T.MediaSubtype>> = []) {
        if !filter.isEmpty {
            let predicates = filter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates + [mediaTypePredicate])
        } else {
            options.predicate = mediaTypePredicate
        }
    }
}
