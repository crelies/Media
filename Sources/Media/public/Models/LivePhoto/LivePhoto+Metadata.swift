//
//  LivePhoto+Metadata.swift
//  Media
//
//  Created by Christian Elies on 21.01.20.
//

import Photos

public extension LivePhoto {
    struct Metadata: AnyMetadata {
        let type: PHAssetMediaType
        let subtypes: PHAssetMediaSubtype
        let sourceType: PHAssetSourceType
        let creationDate: Date?
        let modificationDate: Date?
        let location: CLLocation?
        let isFavorite: Bool
        let isHidden: Bool
    }
}
