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

    private let albumType: AlbumType

    private lazy var albums: [Album] = {
        AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { collection in
            self.albumType.subtypes.contains(collection.assetCollectionSubtype)
        }
    }()

    public var wrappedValue: [Album] { albums }

    /// Initializes the property wrapper using the given album type
    ///
    /// - Parameter type: determines the type of albums to be fetched
    ///
    public init(ofType type: AlbumType) {
        albumType = type
        options.sortDescriptors = defaultSortDescriptors
    }

    /// Initializes the property wrapper using the given album type
    /// Uses the given predicate and the sort descriptors as fetch options
    ///
    /// - Parameters:
    ///   - type: specifies the type of albums to be fetched
    ///   - predicate: determines filters for the album fetch
    ///   - sortDescriptors: descriptors used to sort the fetched albums
    ///
    public init(ofType type: AlbumType,
                predicate: NSPredicate? = nil,
                sortDescriptors: [NSSortDescriptor]? = nil) {
        albumType = type

        options.predicate = predicate

        if let sortDescriptors = sortDescriptors {
            options.sortDescriptors = sortDescriptors
        } else {
            options.sortDescriptors = defaultSortDescriptors
        }
    }
}
