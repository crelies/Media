//
//  PHAssetCollectionWrapper.swift
//  MediaCore
//
//  Created by Christian Elies on 12.02.20.
//

import Photos

final class PHAssetCollectionWrapper {
    var value: PHAssetCollection?

    init(phAssetCollection: PHAssetCollection) {
        value = phAssetCollection
    }
}
