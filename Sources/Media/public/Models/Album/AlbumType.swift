//
//  AlbumType.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Represents the available album
/// types
///
public enum AlbumType {
    case user
    case cloud
    case smart
}

extension AlbumType {
    var assetCollectionType: PHAssetCollectionType {
        switch self {
        case .user, .cloud:
            return .album
        case .smart:
            return .smartAlbum
        }
    }

    var subtypes: [PHAssetCollectionSubtype] {
        switch self {
        case .user:
            return [.albumRegular, .albumSyncedEvent, .albumSyncedFaces, .albumSyncedAlbum, .albumImported]
        case .cloud:
            return [.albumMyPhotoStream, .albumCloudShared]
        case .smart:
            var subtypes: [PHAssetCollectionSubtype] = []

            subtypes.append(.smartAlbumScreenshots)
            subtypes.append(.smartAlbumSelfPortraits)

            if #available(iOS 10.2, macOS 10.13, tvOS 10.1, *) {
                subtypes.append(.smartAlbumDepthEffect)
            }

            if #available(iOS 10.3, macOS 10.13, tvOS 10.2, *) {
                subtypes.append(.smartAlbumLivePhotos)
            }

            if #available(iOS 11, macOS 10.15, tvOS 11, *) {
                subtypes.append(.smartAlbumAnimated)
                subtypes.append(.smartAlbumLongExposures)
            }

            return subtypes + [.smartAlbumGeneric, .smartAlbumPanoramas, .smartAlbumVideos, .smartAlbumFavorites, .smartAlbumTimelapses, .smartAlbumAllHidden, .smartAlbumRecentlyAdded, .smartAlbumBursts, .smartAlbumSlomoVideos, .smartAlbumUserLibrary]
        }
    }
}
