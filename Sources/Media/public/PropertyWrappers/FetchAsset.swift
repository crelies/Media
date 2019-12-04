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
public final class FetchAsset<T: MediaProtocol> {
    private let options = PHFetchOptions().fetchLimit(1)

    private lazy var asset: T? = {
        PHAssetFetcher.fetchAsset(options: options) { asset in
            asset.mediaType == T.type
        }
    }()

    public var wrappedValue: T? { asset }

    /// Initializes the property wrapper with the given predicate
    ///
    /// - Parameter filter: a set of `MediaFilter` to use for the fetch
    ///
    public init(filter: Set<MediaFilter<T.MediaSubtype>> = []) {
        if !filter.isEmpty {
            let predicates = filter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
}
