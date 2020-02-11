//
//  Audio+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension Audio {
    /// Type representing metadata for `Audio`s
    ///
    struct Metadata: AnyMetadata {
        /// Type of the underlying `PHAsset`
        public let type: PHAssetMediaType
        /// Subtypes of the underlying `PHAsset`
        public let subtypes: PHAssetMediaSubtype
        /// Source type (cloud, ...) of the `Audio`
        public let sourceType: PHAssetSourceType
        /// Creation date of the `Audio`
        public let creationDate: Date?
        /// Modification date of the `Audio`
        public let modificationDate: Date?
        /// Location information of the `Audio`
        public let location: CLLocation?
        /// Favorite state of the `Audio`
        public let isFavorite: Bool
        /// Hidden state of the `Audio`
        public let isHidden: Bool
    }
}
