//
//  LazyAlbums.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

import Photos

/// Wrapper type for lazily fetching different types of albums.
public final class LazyAlbums {
    private let albumType: AlbumType?
    private let result: PHFetchResult<PHAssetCollection>

    /// The number of objects in the underlying fetch result.
    public var count: Int { result.count }

    init(albumType: AlbumType?, result: PHFetchResult<PHAssetCollection>) {
        self.albumType = albumType
        self.result = result
    }

    public subscript(index: Int) -> LazyAlbum? {
        guard index >= 0, index < result.count else {
            return nil
        }
        return .init(albumType: albumType, assetCollectionProvider: self.result.object(at: index))
    }
}

public extension LazyAlbums {
    /// All albums in the photo library
    /// sorted by `localizedTitle ascending` provided in a lazy container.
    static var all: LazyAlbums? {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        if let result: PHFetchResult<PHAssetCollection> = try? AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) {
            return .init(albumType: nil, result: result)
        } else {
            return nil
        }
    }

    /// All user albums in the photo library
    /// sorted by `localizedTitle ascending` provided in a lazy container.
    static var user: LazyAlbums? {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albumType: AlbumType = .user
        if let result: PHFetchResult<PHAssetCollection> = try? AlbumFetcher.fetchAlbums(with: albumType.assetCollectionType, subtype: .any, options: options) {
            return .init(albumType: albumType, result: result)
        } else {
            return nil
        }
    }

    /// All smart albums in the photo library
    /// sorted by `localizedTitle ascending` provided in a lazy container.
    static var smart: LazyAlbums? {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albumType: AlbumType = .smart
        if let result: PHFetchResult<PHAssetCollection> = try? AlbumFetcher.fetchAlbums(with: albumType.assetCollectionType, subtype: .any, options: options) {
            return .init(albumType: albumType, result: result)
        } else {
            return nil
        }
    }

    /// All cloud albums in the photo library
    /// sorted by `localizedTitle ascending` provided in a lazy container.
    static var cloud: LazyAlbums? {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albumType: AlbumType = .cloud
        if let result: PHFetchResult<PHAssetCollection> = try? AlbumFetcher.fetchAlbums(with: albumType.assetCollectionType, subtype: .any, options: options) {
            return .init(albumType: albumType, result: result)
        } else {
            return nil
        }
    }
}
