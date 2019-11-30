//
//  AlbumType.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

enum AlbumType {
    case user
    case cloud
    case smart

    var subtypes: [PHAssetCollectionSubtype] {
        switch self {
        case .user:
            return [.albumRegular, .albumSyncedEvent, .albumSyncedFaces, .albumSyncedAlbum, .albumImported]
        case .cloud:
            return [.albumMyPhotoStream, .albumCloudShared]
        case .smart:
            var subtypes: [PHAssetCollectionSubtype] = []

            if #available(iOS 9, *) {
                subtypes.append(.smartAlbumScreenshots)
                subtypes.append(.smartAlbumSelfPortraits)
            }

            if #available(iOS 10.2, *) {
                subtypes.append(.smartAlbumDepthEffect)
            }

            if #available(iOS 10.3, *) {
                subtypes.append(.smartAlbumLivePhotos)
            }

            if #available(iOS 11, *) {
                subtypes.append(.smartAlbumAnimated)
                subtypes.append(.smartAlbumLongExposures)
            }

            return subtypes + [.smartAlbumGeneric, .smartAlbumPanoramas, .smartAlbumVideos, .smartAlbumFavorites, .smartAlbumTimelapses, .smartAlbumAllHidden, .smartAlbumRecentlyAdded, .smartAlbumBursts, .smartAlbumSlomoVideos, .smartAlbumUserLibrary]
        }
    }
}
