//
//  PHImageManager+LivePhotoManager.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

import Photos

extension PHImageManager: LivePhotoManager {
    typealias CustomRequestLivePhotoCompletion = (PHLivePhotoProtocol?, [AnyHashable : Any]?) -> Void

    func customRequestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping CustomRequestLivePhotoCompletion) -> PHImageRequestID {
        requestLivePhoto(for: asset, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: resultHandler)
    }
}
