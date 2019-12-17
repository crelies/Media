//
//  PHLivePhotoProtocol.swift
//  Media
//
//  Created by Christian Elies on 15.12.19.
//

import Photos
#if canImport(UIKit)
import UIKit
#endif

public protocol PHLivePhotoProtocol {
    var size: CGSize { get }
    #if canImport(UIKit)
    static func request(withResourceFileURLs fileURLs: [URL], placeholderImage image: UIImage?, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]) -> Void) -> PHLivePhotoRequestID
    #endif
    @available(macOS 10.15, *)
    static func cancelRequest(withRequestID requestID: PHLivePhotoRequestID)
}
