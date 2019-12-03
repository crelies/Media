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
    private let mediaTypePredicate = NSPredicate(format: "mediaType = %d", T.type.rawValue)
    private let defaultSortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

    private lazy var assets: [T] = {
        PHAssetFetcher.fetchAssets(options: options)
    }()
    private let options: PHFetchOptions

    public var wrappedValue: [T] { assets }

    /// Initializes the property wrapper using a default sort descriptor
    /// (sort by `creationDate descending`)
    ///
    public init() {
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = defaultSortDescriptors
        self.options = options
    }

    /// Initializes the property wrapper using the given predicate and sort descriptors
    /// to define the `PHFetchOptions`
    ///
    /// - Parameters:
    ///   - predicate: a predicate for filtering the assets
    ///   - sortDescriptors: descriptors for sorting the results
    ///
    public init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        let options = PHFetchOptions()

        if let additionalPredicate = predicate {
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate, additionalPredicate])
        } else {
            options.predicate = mediaTypePredicate
        }

        if let sortDescriptors = sortDescriptors {
            options.sortDescriptors = sortDescriptors
        } else {
            options.sortDescriptors = defaultSortDescriptors
        }

        self.options = options
    }
}
