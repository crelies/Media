//
//  LivePhoto+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension LivePhoto {
    /// Represents locally available metadata
    /// of a live photo
    ///
    struct Metadata: AnyMetadata {
        /// Get the `PHAssetMediaType` of the receiving live photo
        ///
        public let type: PHAssetMediaType
        /// Subtypes of type `PHAssetMediaSubtype` related to the
        /// receiving live photo
        ///
        public let subtypes: PHAssetMediaSubtype
        /// Source type of the live photo, like
        /// iCloud or iTunes synced
        ///
        public let sourceType: PHAssetSourceType
        /// Creation date of the receiving live photo
        public let creationDate: Date?
        /// Modification date of the receiving live photo
        public let modificationDate: Date?
        /// Location data which determines where the
        /// live photo was taken
        ///
        public let location: CLLocation?
        /// Favorite state of the receiving live photo
        public let isFavorite: Bool
        /// Hidden state of the receiving live photo
        public let isHidden: Bool
    }
}
