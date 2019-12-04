//
//  FetchAlbum.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Photos

/// Property wrapper for fetching a single album
///
@propertyWrapper
public final class FetchAlbum {
    private let options = PHFetchOptions().fetchLimit(1)

    private lazy var album: Album? = {
        AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options)
    }()

    public var wrappedValue: Album? { album }

    /// Initializes the property wrapper using the given predicate
    /// as the fetch options
    ///
    /// - Parameter predicate: predicate used as a fetch filter
    ///
    public init(predicate: NSPredicate) {
        options.predicate = predicate
    }
}
