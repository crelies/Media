//
//  FetchAlbums.swift
//  
//
//  Created by Christian Elies on 03.12.19.
//

import Photos

/// Property wrapper for fetching albums
///
@available(macOS 10.15, *)
@propertyWrapper
public struct FetchAlbums {
    private let options = PHFetchOptions()
    private let defaultSort: Sort<Album.SortKey> = Sort(key: .localizedTitle, ascending: true)

    private let albumType: AlbumType?

    public var wrappedValue: [Album] {
        (try? AlbumFetcher.fetchAlbums(with: (albumType?.assetCollectionType) ?? .album,
                                 subtype: .any,
                                 options: options) { collection in
            self.albumType?.subtypes.contains(collection.assetCollectionSubtype) ?? true
        }) ?? []
    }

    /// Initializes the property wrapper without an album type filter and
    /// with a default sort descriptor (sort by `localizedTitle ascending`)
    ///
    public init() {
        albumType = nil
        options.sortDescriptors = [defaultSort.sortDescriptor]
    }

    /// Initializes the property wrapper using the given album type
    /// Uses the given predicate and the sort descriptors as fetch options
    ///
    /// - Parameters:
    ///   - type: specifies the type of albums to be fetched, fetches all albums if nil
    ///   - filter: a set of `AlbumFilter` for the fetch, defaults to empty
    ///   - sort: a set of `Sort<AlbumSortKey>` for the fetch, defaults to empty
    ///   - fetchLimit: a maximum number of results to fetch, defaults to 0 (no limit)
    ///
    public init(ofType type: AlbumType? = nil,
                filter: Set<Album.Filter> = [],
                sort: Set<Sort<Album.SortKey>> = [],
                fetchLimit: Int = 0) {
        albumType = type

        if !filter.isEmpty {
            let predicates = filter.map { $0.predicate }
            options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        var sortKeys = sort
        sortKeys.insert(defaultSort)

        if !sortKeys.isEmpty {
            let sortDescriptors = sortKeys.map { $0.sortDescriptor }
            options.sortDescriptors = sortDescriptors
        }

        options.fetchLimit = fetchLimit
    }
}
