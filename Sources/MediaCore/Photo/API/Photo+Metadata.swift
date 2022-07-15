//
//  Photo+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension Photo {
    /// Locally available metadata of a `Photo`
    ///
    struct Metadata: AnyMetadata {
        /// `PHAssetMediaType` of the receiving photo
        ///
        public let type: PHAssetMediaType
        /// Subtypes of the photo, like `photoHDR`
        ///
        public let subtypes: PHAssetMediaSubtype
        /// Source type of the photo, like iCloud
        ///
        public let sourceType: PHAssetSourceType
        /// Creation date of the photo
        ///
        public let creationDate: Date?
        /// Modification date of the photo
        ///
        public let modificationDate: Date?
        /// Location where the photo was taken
        ///
        public let location: CLLocation?
        /// Favorite state of the receiving photo
        ///
        public let isFavorite: Bool
        /// Hidden state of the photo
        ///
        public let isHidden: Bool
        // The width, in pixels, of the asset’s image or video data.
        ///
        public let pixelWidth: Int
        // The height, in pixels, of the asset’s image or video data.
        ///
        public let pixelHeight: Int
    }
}
