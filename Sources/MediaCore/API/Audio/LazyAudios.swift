//
//  LazyAudios.swift
//  MediaCore
//
//  Created by Christian Elies on 21.02.21.
//

import Photos

/// Wrapper type for lazily fetching audios.
public final class LazyAudios {
    private let result: PHFetchResult<PHAsset>

    /// The number of objects in the underlying fetch result.
    public var count: Int { result.count }

    init(result: PHFetchResult<PHAsset>) {
        self.result = result
    }

    public subscript(index: Int) -> Audio? {
        guard index >= 0, index < result.count else {
            return nil
        }
        let asset = result.object(at: index)
        return .init(phAsset: asset)
    }
}

public extension LazyAudios {
    /// All audios in the photo library
    /// sorted by `creationDate descending` provided in a lazy container.
    static var all: LazyAudios? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Audio.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        if let result = try? PHAssetFetcher.fetchAssets(options: options) {
            return .init(result: result)
        } else {
            return nil
        }
    }()
}
