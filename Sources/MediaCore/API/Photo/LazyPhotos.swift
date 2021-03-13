//
//  LazyPhotos.swift
//  MediaCore
//
//  Created by Christian Elies on 21.02.21.
//

import Photos

extension Media {
    /// <#Description#>
    public final class LazyPhotos {
        private let result: PHFetchResult<PHAsset>

        /// <#Description#>
        public var count: Int { result.count }

        init(result: PHFetchResult<PHAsset>) {
            self.result = result
        }

        public subscript(index: Int) -> Photo? {
            guard index >= 0, index < result.count else {
                return nil
            }
            let asset = result.object(at: index)
            return .init(phAsset: asset)
        }
    }
}

public extension Media.LazyPhotos {
    /// <#Description#>
    static var all: Media.LazyPhotos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
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
    static var live: LazyLivePhotos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", LivePhoto.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<LivePhoto.MediaSubtype>.mediaSubtypes([.live])
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
    static var panorama: Media.LazyPhotos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Photo.MediaSubtype>.mediaSubtypes([.panorama])
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
    static var hdr: Media.LazyPhotos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Photo.MediaSubtype>.mediaSubtypes([.hdr])
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
    static var screenshot: Media.LazyPhotos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Photo.MediaSubtype>.mediaSubtypes([.screenshot])
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

    @available(iOS 10.2, macOS 10.15, tvOS 10.1, *)
    /// <#Description#>
    static var depthEffect: Media.LazyPhotos? = {
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
        let mediaSubtypeFilter = Media.Filter<Photo.MediaSubtype>.mediaSubtypes([.depthEffect])
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