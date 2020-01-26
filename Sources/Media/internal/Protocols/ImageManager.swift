//
//  ImageManager.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

import Photos
#if canImport(UIKit)
import UIKit

typealias RequestImageResultHandler = (UIImage?, [AnyHashable : Any]?) -> Void
#endif

typealias RequestImageDataAndOrientationResultHandler = (Data?, String?, CGImagePropertyOrientation, [AnyHashable : Any]?) -> Void

protocol ImageManager {
    #if canImport(UIKit)
    @discardableResult
    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping RequestImageResultHandler) -> PHImageRequestID
    #endif

    @available(iOS 13, macOS 10.15, tvOS 13, *)
    @discardableResult
    func requestImageDataAndOrientation(for asset: PHAsset, options: PHImageRequestOptions?, resultHandler: @escaping RequestImageDataAndOrientationResultHandler) -> PHImageRequestID
}
