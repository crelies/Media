//
//  PHLivePhotoProtocol.swift
//  Media
//
//  Created by Christian Elies on 15.12.19.
//

import Photos
import UIKit

public protocol PHLivePhotoProtocol {
    var size: CGSize { get }
    static func request(withResourceFileURLs fileURLs: [URL], placeholderImage image: UIImage?, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]) -> Void) -> PHLivePhotoRequestID
    static func cancelRequest(withRequestID requestID: PHLivePhotoRequestID)
}
