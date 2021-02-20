//
//  LazyAlbums.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

import Photos

/// <#Description#>
public final class LazyAlbums {
    /// <#Description#>
    public static var all: [LazyAlbum] = {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albums = (try? AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)) ?? []
        return albums.compactMap(LazyAlbum.init)
    }()

    /// <#Description#>
    public static var user: [LazyAlbum] = {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albumType: AlbumType = .cloud
        let albums = (try? AlbumFetcher.fetchAlbums(with: albumType.assetCollectionType, subtype: .any, options: options) { collection in
            albumType.subtypes.contains(collection.assetCollectionSubtype)
        }) ?? []
        return albums.compactMap(LazyAlbum.init)
    }()

    /// <#Description#>
    public static var smart: [LazyAlbum] = {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albumType: AlbumType = .smart
        let albums = (try? AlbumFetcher.fetchAlbums(with: albumType.assetCollectionType, subtype: .any, options: options) { collection in
            albumType.subtypes.contains(collection.assetCollectionSubtype)
        }) ?? []
        return albums.compactMap(LazyAlbum.init)
    }()

    /// <#Description#>
    public static var cloud: [LazyAlbum] = {
        let options = PHFetchOptions()
        let defaultSort: Media.Sort<Album.SortKey> = Media.Sort(key: .localizedTitle, ascending: true)
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let albumType: AlbumType = .cloud
        let albums = (try? AlbumFetcher.fetchAlbums(with: albumType.assetCollectionType, subtype: .any, options: options) { collection in
            albumType.subtypes.contains(collection.assetCollectionSubtype)
        }) ?? []
        return albums.compactMap(LazyAlbum.init)
    }()
}
