//
//  LazyAlbum.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

import Photos

/// Wrapper type for lazily fetching an album.
public final class LazyAlbum: Identifiable {
    private let albumType: AlbumType?
    private let assetCollectionProvider: () -> PHAssetCollection
    private lazy var album: Album? = {
        let assetCollection = assetCollectionProvider()
        if let albumType = albumType {
            guard albumType.subtypes.contains(assetCollection.assetCollectionSubtype) else {
                return nil
            }
        }
        return Album(phAssetCollection: assetCollection)
    }()

    private let uuid = UUID().uuidString

    public var id: String { uuid }

    /// The estimated number of assets in the underlying asset collection.
    public var estimatedAssetCount: Int {
        guard let estimatedAssetCount = album?.phAssetCollection?.estimatedAssetCount else {
            return 0
        }
        return estimatedAssetCount != NSNotFound ? estimatedAssetCount : 1
    }

    /// The localizedTitle of the underlying `PHAssetCollection`.
    public var localizedTitle: String? { album?.localizedTitle }

    /// The audios of the album, provided in a lazy container.
    public var audios: LazyAudios? {
        guard Media.isAccessAllowed else {
            return nil
        }
        guard let assetCollection = album?.phAssetCollection else {
            return nil
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Audio.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let result = PHAsset.fetchAssets(in: assetCollection, options: options)
        return .init(result: result)
    }

    /// The photos of the album, provided in a lazy container.
    public var photos: Media.LazyPhotos? {
        guard Media.isAccessAllowed else {
            return nil
        }
        guard let assetCollection = album?.phAssetCollection else {
            return nil
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Photo.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let result = PHAsset.fetchAssets(in: assetCollection, options: options)
        return .init(result: result)
    }

    /// The videos of the album, provided in a lazy container.
    public var videos: LazyVideos? {
        guard Media.isAccessAllowed else {
            return nil
        }
        guard let assetCollection = album?.phAssetCollection else {
            return nil
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", Video.type.rawValue)
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = mediaTypePredicate
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let result = PHAsset.fetchAssets(in: assetCollection, options: options)
        return .init(result: result)
    }

    /// The live photos of the album, provided in a lazy container.
    public var livePhotos: LazyLivePhotos? {
        guard Media.isAccessAllowed else {
            return nil
        }
        guard let assetCollection = album?.phAssetCollection else {
            return nil
        }
        let mediaTypePredicate: NSPredicate = NSPredicate(format: "mediaType = %d", LivePhoto.type.rawValue)
        let mediaSubtypeFilter: Media.Filter<LivePhoto.MediaSubtype> = Media.Filter.mediaSubtypes([.live])
        let mediaSubtypePredicate = mediaSubtypeFilter.predicate
        let defaultSort: Media.Sort<Media.SortKey> = Media.Sort(key: .creationDate, ascending: false)
        let options = PHFetchOptions()
        options.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [mediaTypePredicate, mediaSubtypePredicate])
        options.sortDescriptors = [defaultSort.sortDescriptor]
        options.fetchLimit = 0
        let result = PHAsset.fetchAssets(in: assetCollection, options: options)
        return .init(result: result)
    }

    init(albumType: AlbumType?, assetCollectionProvider: @autoclosure @escaping () -> PHAssetCollection) {
        self.albumType = albumType
        self.assetCollectionProvider = assetCollectionProvider
    }
}

public extension LazyAlbum {
    /// Deletes the receiver if access to the photo library is allowed.
    ///
    /// - Parameter completion: A closure which gets the Result (`Void` on success and `Error` on failure).
    func delete(completion: @escaping ResultVoidCompletion) {
        album?.delete(completion: completion)
    }
}
