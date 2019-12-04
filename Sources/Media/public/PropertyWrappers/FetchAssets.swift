//
//  FetchAssets.swift
//  
//
//  Created by Christian Elies on 03.12.19.
//

import Photos

/// Generic property wrapper for fetching assets from the photo library
/// Fetches the assets lazily (after accessing the property)
///
@propertyWrapper
public final class FetchAssets<T: MediaProtocol> {
    private let options = PHFetchOptions()
    private let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", T.type.rawValue)
    private let defaultSort: Sort<MediaSortKey> = Sort(key: .creationDate, ascending: false)

    private lazy var assets: [T] = {
        PHAssetFetcher.fetchAssets(options: options)
    }()

    public var wrappedValue: [T] { assets }

    /// Initializes the property wrapper using a default sort descriptor
    /// (sort by `creationDate descending`)
    ///
    public init() {
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
    }

    /// Initializes the property wrapper using the given predicate and sort descriptors
    /// to define the `PHFetchOptions`
    ///
    /// - Parameters:
    ///   - filter: a set of `MediaFilter` for filtering the assets
    ///   - sort: a set of `Sort<MediaSortKey>` for sorting the assets
    ///
    public init(filter: Set<MediaFilter<T.MediaSubtype>> = [],
                sort: Set<Sort<MediaSortKey>> = []) {
        if !filter.isEmpty {
            let predicates = filter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates + [mediaTypePredicate])
        } else {
            options.predicate = mediaTypePredicate
        }

        var sortKeys = sort
        sortKeys.insert(defaultSort)

        if !sortKeys.isEmpty {
            let sortDescriptors = sortKeys.map { $0.sortDescriptor }
            options.sortDescriptors = sortDescriptors
        }
    }
}
