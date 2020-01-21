//
//  AnyMetadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import CoreLocation
import Photos

protocol AnyMetadata {
    // The type of the asset, such as video or audio.
    var type: PHAssetMediaType { get }

    // The subtypes of the asset, identifying special kinds of assets such as panoramic photo or high-framerate video.
    var subtypes: PHAssetMediaSubtype { get }

    // The means by which the asset entered the user’s Photos library.
    var sourceType: PHAssetSourceType { get }

    // The date and time at which the asset was originally created.
    var creationDate: Date? { get }

    // The date and time at which the asset was last modified.
    var modificationDate: Date? { get }

    // The location information saved with the asset.
    var location: CLLocation? { get }

    // A Boolean value that indicates whether the user has marked the asset as a favorite.
    var isFavorite: Bool { get }

    // A Boolean value that indicates whether the user has hidden the asset.
    var isHidden: Bool { get }
}
