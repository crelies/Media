//
//  Photo+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension Photo {
    struct Metadata: AnyMetadata {
        let type: PHAssetMediaType
        let subtypes: PHAssetMediaSubtype
        let sourceType: PHAssetSourceType
        let creationDate: Date?
        let modificationDate: Date?
        let location: CLLocation?
        let isFavorite: Bool
        let isHidden: Bool

        // The width, in pixels, of the asset’s image or video data.
        let pixelWidth: Int

        // The height, in pixels, of the asset’s image or video data.
        let pixelHeight: Int
    }
}
