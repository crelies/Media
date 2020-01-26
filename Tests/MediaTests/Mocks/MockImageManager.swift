//
//  MockImageManager.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

#if canImport(UIKit)
@testable import Media
import Photos
import UIKit

final class MockImageManager: ImageManager {
    var mockRequestID = PHImageRequestID()

    func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?, resultHandler: @escaping RequestImageResultHandler) -> PHImageRequestID {
        return mockRequestID
    }

    func requestImageDataAndOrientation(for asset: PHAsset, options: PHImageRequestOptions?, resultHandler: @escaping RequestImageDataAndOrientationResultHandler) -> PHImageRequestID {
        return mockRequestID
    }
}
#endif
