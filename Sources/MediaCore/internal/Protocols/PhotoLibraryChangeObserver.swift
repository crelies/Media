//
//  PhotoLibraryChangeObserver.swift
//  Media
//
//  Created by Christian Elies on 01.02.20.
//

import Photos

protocol PhotoLibraryChangeObserver: PHPhotoLibraryChangeObserver where Self: NSObject {
    init(asset: PHAsset, _ completion: @escaping ResultPHAssetCompletion)
}
