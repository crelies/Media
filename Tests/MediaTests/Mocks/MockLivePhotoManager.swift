//
//  MockLivePhotoManager.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import Photos

final class MockLivePhotoManager: LivePhotoManager {
    var mockRequestID = PHImageRequestID()

    func requestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return mockRequestID
    }
}
