//
//  LazyVideos.swift
//  MediaCore
//
//  Created by Christian Elies on 21.02.21.
//

import Photos

/// <#Description#>
public final class LazyVideos {
    private let result: PHFetchResult<PHAsset>

    /// <#Description#>
    public var count: Int { result.count }

    init(result: PHFetchResult<PHAsset>) {
        self.result = result
    }

    public subscript(index: Int) -> Video? {
        guard index >= 0, index < result.count else {
            return nil
        }
        let asset = result.object(at: index)
        return .init(phAsset: asset)
    }
}

public extension LazyVideos {
    /// <#Description#>
    static var all: LazyVideos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Video.type.rawValue)
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

    /// <#Description#>
    static var streams: LazyVideos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Video.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Video.MediaSubtype>.mediaSubtypes([.streamed])
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate, mediaSubtypeFilter.predicate])
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        if let result = try? PHAssetFetcher.fetchAssets(options: options) {
            return .init(result: result)
        } else {
            return nil
        }
    }()

    /// <#Description#>
    static var highFrameRates: LazyVideos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Video.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Video.MediaSubtype>.mediaSubtypes([.highFrameRate])
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate, mediaSubtypeFilter.predicate])
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        if let result = try? PHAssetFetcher.fetchAssets(options: options) {
            return .init(result: result)
        } else {
            return nil
        }
    }()

    /// <#Description#>
    static var timelapses: LazyVideos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Video.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Video.MediaSubtype>.mediaSubtypes([.timelapse])
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate, mediaSubtypeFilter.predicate])
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        if let result = try? PHAssetFetcher.fetchAssets(options: options) {
            return .init(result: result)
        } else {
            return nil
        }
    }()
}
