//
//  FetchAllAssets.swift
//  MediaCore
//
//  Created by Christian Elies on 13.02.21.
//

import Photos

/// Property wrapper for fetching all assets from the photo library.
/// Fetches the assets lazily (after accessing the property).
///
@propertyWrapper
public struct FetchAllAssets {
    static var phAsset: PHAsset.Type = PHAsset.self

    private var assetCollection: PHAssetCollection?
    private let options = PHFetchOptions()
    private let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)

    /// Wrapped array of `AnyMedia` instances.
    public var wrappedValue: [AnyMedia] {
        let result: PHFetchResult<PHAsset>
        if let assetCollection = assetCollection {
            result = Self.phAsset.fetchAssets(in: assetCollection, options: options)
        } else {
            result = Self.phAsset.fetchAssets(with: options)
        }
        var media: [AnyMedia] = []
        result.enumerateObjects { asset, _, _ in
            guard let anyMedia = asset.anyMedia else {
                return
            }
            media.append(anyMedia)
        }
        return media
    }

    /// Initializes the property wrapper using a default sort descriptor
    /// (sort by `creationDate descending`).
    ///
    public init() {
        options.sortDescriptors = [defaultSort.sortDescriptor]
    }

    /// Initializes the property wrapper using the given sort descriptors
    /// to define the `PHFetchOptions`.
    ///
    /// - Parameters:
    ///   - assetCollection: limits the fetch to a specific asset collection, by default all assets in the library are taken into account.
    ///   - sort: a set of `Sort<MediaSortKey>` for sorting the assets
    ///   - fetchLimit: a maximum number of results to fetch, defaults to 0 (no limit)
    ///   - includeAllBurstAssets: a Boolean value that determines whether the fetch result includes all assets from burst photo sequences, defaults to false
    ///   - includeHiddenAssets: a Boolean value that determines whether the fetch result includes assets marked as hidden, defaults to false
    ///
    public init(
        in assetCollection: PHAssetCollection? = nil,
        sort: Set<Media.Sort<Media.SortKey>> = [],
        fetchLimit: Int = 0,
        includeAllBurstAssets: Bool = false,
        includeHiddenAssets: Bool = false
    ) {
        self.assetCollection = assetCollection

        var sortKeys = sort
        sortKeys.insert(defaultSort)

        if !sortKeys.isEmpty {
            let sortDescriptors = sortKeys.map { $0.sortDescriptor }
            options.sortDescriptors = sortDescriptors
        }

        options.fetchLimit = fetchLimit
        options.includeAllBurstAssets = includeAllBurstAssets
        options.includeHiddenAssets = includeHiddenAssets
    }
}
