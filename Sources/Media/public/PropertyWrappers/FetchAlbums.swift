//
//  FetchAlbums.swift
//  
//
//  Created by Christian Elies on 03.12.19.
//

import Photos

/// Property wrapper for fetching albums
///
@propertyWrapper
public final class FetchAlbums {
    private let options = PHFetchOptions()
    private let defaultSortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]

    private let albumType: AlbumType?

    private lazy var albums: [Album] = {
        AlbumFetcher.fetchAlbums(with: (albumType?.assetCollectionType) ?? .album,
                                 subtype: .any,
                                 options: options) { collection in
            self.albumType?.subtypes.contains(collection.assetCollectionSubtype) ?? true
        }
    }()

    public var wrappedValue: [Album] { albums }

    /// Initializes the property wrapper without an album type filter and
    /// with a default sort descriptor (sort by `localizedTitle ascending`)
    ///
    public init() {
        albumType = nil
        options.sortDescriptors = defaultSortDescriptors
    }

    /// Initializes the property wrapper using the given album type
    /// Uses the given predicate and the sort descriptors as fetch options
    ///
    /// - Parameters:
    ///   - type: specifies the type of albums to be fetched, fetches all albums if nil
    ///   - filter: a set of `AlbumFilter` for the fetch
    ///   - sortDescriptors: descriptors used to sort the fetched albums
    ///
    public init(ofType type: AlbumType? = nil,
                filter: Set<AlbumFilter> = [],
                sortDescriptors: [NSSortDescriptor]? = nil) {
        albumType = type

        if !filter.isEmpty {
            let predicates = filter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        if let sortDescriptors = sortDescriptors {
            options.sortDescriptors = sortDescriptors
        } else {
            options.sortDescriptors = defaultSortDescriptors
        }
    }
}
