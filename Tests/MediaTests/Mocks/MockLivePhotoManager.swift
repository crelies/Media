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

    var livePhotoToReturn: PHLivePhotoProtocol?
    var infoToReturn: [AnyHashable:Any]?
    func customRequestLivePhoto(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode, options: PHLivePhotoRequestOptions?, resultHandler: @escaping (PHLivePhotoProtocol?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        resultHandler(livePhotoToReturn, infoToReturn)
        return mockRequestID
    }
}
