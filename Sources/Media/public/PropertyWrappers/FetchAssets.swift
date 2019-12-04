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
    private let mediaTypeFilter: MediaFilter = .mediaType(T.type)
    private let defaultSortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

    private lazy var assets: [T] = {
        PHAssetFetcher.fetchAssets(options: options)
    }()

    public var wrappedValue: [T] { assets }

    /// Initializes the property wrapper using a default sort descriptor
    /// (sort by `creationDate descending`)
    ///
    public init() {
        options.predicate = mediaTypeFilter.predicate
        options.sortDescriptors = defaultSortDescriptors
    }

    /// Initializes the property wrapper using the given predicate and sort descriptors
    /// to define the `PHFetchOptions`
    ///
    /// - Parameters:
    ///   - predicate: a predicate for filtering the assets
    ///   - sortDescriptors: descriptors for sorting the results
    ///
    public init(filter: Set<MediaFilter> = [], sortDescriptors: [NSSortDescriptor]? = nil) {
        var mediaFilter = filter
        mediaFilter.insert(mediaTypeFilter)

        if !mediaFilter.isEmpty {
            let predicates = mediaFilter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        if let sortDescriptors = sortDescriptors {
            options.sortDescriptors = sortDescriptors
        } else {
            options.sortDescriptors = defaultSortDescriptors
        }
    }
}
