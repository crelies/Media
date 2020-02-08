//
//  Video+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension Video {
    struct Metadata: AnyMetadata {
        public let type: PHAssetMediaType
        public let subtypes: PHAssetMediaSubtype
        public let sourceType: PHAssetSourceType
        public let creationDate: Date?
        public let modificationDate: Date?
        public let location: CLLocation?
        public let isFavorite: Bool
        public let isHidden: Bool

        // The width, in pixels, of the asset’s image or video data.
        public let pixelWidth: Int

        // The height, in pixels, of the asset’s image or video data.
        public let pixelHeight: Int

        // The duration, in seconds, of the video asset.
        public let duration: TimeInterval
    }
}
