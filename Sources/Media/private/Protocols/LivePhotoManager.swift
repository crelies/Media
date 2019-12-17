//
//  LivePhotoManager.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

import Photos

protocol LivePhotoManager {
    // TODO: 10.13
    @available(macOS 10.15, *)
    @discardableResult
    func customRequestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping (PHLivePhotoProtocol?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
}
