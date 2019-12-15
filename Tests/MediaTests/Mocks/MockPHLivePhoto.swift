//
//  MockPHLivePhoto.swift
//  MediaTests
//
//  Created by Christian Elies on 15.12.19.
//

@testable import Media
import Photos
import UIKit

final class MockPHLivePhoto: PHLivePhotoProtocol {
    static var livePhotoRequestID = PHLivePhotoRequestID()

    var size: CGSize = CGSize(width: 20, height: 20)

    static func request(withResourceFileURLs fileURLs: [URL], placeholderImage image: UIImage?, targetSize: CGSize, contentMode: PHImageContentMode, resultHandler: @escaping (PHLivePhoto?, [AnyHashable : Any]) -> Void) -> PHLivePhotoRequestID {
        livePhotoRequestID
    }

    static func cancelRequest(withRequestID requestID: PHLivePhotoRequestID) {}
}
