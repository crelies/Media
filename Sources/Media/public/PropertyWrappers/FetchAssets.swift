//
//  FetchAssets.swift
//  
//
//  Created by Christian Elies on 03.12.19.
//

import Photos

@propertyWrapper
public final class FetchAssets<T: MediaProtocol> {
    private let mediaTypePredicate = NSPredicate(format: "mediaType = %d", T.type.rawValue)
    private let defaultSortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

    private lazy var assets: [T] = {
        PHAssetFetcher.fetchAssets(options: options)
    }()
    private let options: PHFetchOptions

    public var wrappedValue: [T] { assets }

    public init() {
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = defaultSortDescriptors
        self.options = options
    }

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
