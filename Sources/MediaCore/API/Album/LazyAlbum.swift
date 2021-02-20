//
//  LazyAlbum.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

import Photos

/// <#Description#>
public final class LazyAlbum {
    private var _album: Album?

    /// <#Description#>
    public enum Error: Swift.Error {
        ///
        case notFound
    }

    /// <#Description#>
    public let identifier: Album.Identifier

    /// <#Description#>
    public var audios: [LazyAudio] {
        guard let album = try? album() else {
            return []
        }
        guard let assetCollection = album.phAssetCollection else {
            return []
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Audio.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let assets: [Audio] = (try? PHAssetFetcher.fetchAssets(in: assetCollection, options: options)) ?? []
        return assets.compactMap(LazyAudio.init)
    }

    /// <#Description#>
    public var photos: [LazyPhoto] {
        guard let album = try? album() else {
            return []
        }
        guard let assetCollection = album.phAssetCollection else {
            return []
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let assets: [Photo] = (try? PHAssetFetcher.fetchAssets(in: assetCollection, options: options)) ?? []
        return assets.compactMap(LazyPhoto.init)
    }

    /// <#Description#>
    public var videos: [LazyVideo] {
        guard let album = try? album() else {
            return []
        }
        guard let assetCollection = album.phAssetCollection else {
            return []
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Video.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let assets: [Video] = (try? PHAssetFetcher.fetchAssets(in: assetCollection, options: options)) ?? []
        return assets.compactMap(LazyVideo.init)
    }

    /// <#Description#>
    public var livePhotos: [LazyLivePhoto] {
        guard let album = try? album() else {
            return []
        }
        guard let assetCollection = album.phAssetCollection else {
            return []
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", LivePhoto.type.rawValue)
        let mediaSubtypeFilter: Media.Filter<LivePhoto.MediaSubtype> = Media.Filter.mediaSubtypes([.live])
        let mediaSubtypePredicate = mediaSubtypeFilter.predicate
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate] + [mediaSubtypePredicate])
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let assets: [LivePhoto] = (try? PHAssetFetcher.fetchAssets(in: assetCollection, options: options)) ?? []
        return assets.compactMap(LazyLivePhoto.init)
    }

    init(identifier: Album.Identifier) {
        self.identifier = identifier
    }

    init?(album: Album) {
        guard let localIdentifier = album.identifier else {
            return nil
        }
        self.identifier = .init(localIdentifier: localIdentifier)
    }

    /// <#Description#>
    /// 
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    public func album() throws -> Album {
        if let _album = _album {
            return _album
        }

        guard let album = try Album.with(identifier: identifier) else {
            throw Error.notFound
        }

        _album = album

        return album
    }
}
