//
//  MockVideoManager.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import Photos

final class MockVideoManager: VideoManager {
    var mockRequestID = PHImageRequestID()

    func requestPlayerItem(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return mockRequestID
    }

    func requestExportSession(forVideo asset: PHAsset, options: PHVideoRequestOptions?, exportPreset: String, resultHandler: @escaping (AVAssetExportSession?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return mockRequestID
    }

    func requestAVAsset(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return mockRequestID
    }
}
