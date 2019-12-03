//
//  FetchAssets.swift
//  
//
//  Created by Christian Elies on 03.12.19.
//

import Photos

@propertyWrapper
public final class FetchAssets<T: MediaProtocol> {
    private lazy var assets: [T] = {
        PHAssetFetcher.fetchAssets(options: options)
    }()
    private let options: PHFetchOptions

    public var wrappedValue: [T] { assets }

    public init() {
        self.options = PHFetchOptions()
    }

    public init(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) {
        let options = PHFetchOptions()
        options.predicate = predicate
        options.sortDescriptors = sortDescriptors
        self.options = options
    }
}
