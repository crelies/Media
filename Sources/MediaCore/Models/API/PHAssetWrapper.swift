//
//  PHAssetWrapper.swift
//  MediaCore
//
//  Created by Christian Elies on 27.01.20.
//

import Photos

/// Box type for storing a reference to
/// a `PHAsset` instance
///
// TODO: Concurrency
public final class PHAssetWrapper: Sendable {
    var value: PHAsset?

    init(value: PHAsset) {
        self.value = value
    }
}
