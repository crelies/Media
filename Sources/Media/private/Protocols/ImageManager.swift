//
//  ImageManager.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

import Photos
import UIKit

protocol ImageManager {
    @discardableResult
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID

    @available(iOS 13, *)
    @discardableResult
    func requestImageDataAndOrientation(for asset: PHAsset, options: PHImageRequestOptions?, resultHandler: @escaping (Data?, String?, CGImagePropertyOrientation, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
}
