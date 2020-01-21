//
//  Audio+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension Audio {
    struct Metadata: AnyMetadata {
        public let type: PHAssetMediaType
        public let subtypes: PHAssetMediaSubtype
        public let sourceType: PHAssetSourceType
        public let creationDate: Date?
        public let modificationDate: Date?
        public let location: CLLocation?
        public let isFavorite: Bool
        public let isHidden: Bool
    }
}
