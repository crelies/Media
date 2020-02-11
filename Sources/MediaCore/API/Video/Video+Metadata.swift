//
//  Video+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension Video {
    /// Type representing video metadata
    /// which is mostly locally available
    ///
    struct Metadata: AnyMetadata {
        /// Type of the underlying `PHAsset`
        public let type: PHAssetMediaType
        /// Subtypes of the underlying `PHAsset`
        public let subtypes: PHAssetMediaSubtype
        /// Source type (cloud, ...) of the underlying `PHAsset`
        public let sourceType: PHAssetSourceType
        /// Creation date of the `Video`
        public let creationDate: Date?
        /// Last modification date of the `Video`
        public let modificationDate: Date?
        /// Location where the `Video` was taken
        public let location: CLLocation?
        /// Favorite state of the `Video`
        public let isFavorite: Bool
        /// Hidden state of the `Video`
        public let isHidden: Bool
        // The width, in pixels, of the asset’s image or video data.
        public let pixelWidth: Int
        // The height, in pixels, of the asset’s image or video data.
        public let pixelHeight: Int
        // The duration, in seconds, of the video asset.
        public let duration: TimeInterval
    }
}
