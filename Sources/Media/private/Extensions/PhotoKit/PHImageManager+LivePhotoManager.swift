//
//  PHImageManager+LivePhotoManager.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

import Photos

extension PHImageManager: LivePhotoManager {
    func customRequestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping (PHLivePhotoProtocol?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        requestLivePhoto(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: resultHandler)
    }
}
