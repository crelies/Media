//
//  MockVideoManager.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import MediaCore
import Photos

final class MockVideoManager: VideoManager {
    var mockRequestID = PHImageRequestID()
    var avPlayerItemToReturn: AVPlayerItem?
    var avAssetToReturn: AVAsset?
    var infoToReturn: [AnyHashable : Any]?

    func requestPlayerItem(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        resultHandler(avPlayerItemToReturn, infoToReturn)
        return mockRequestID
    }

    func requestExportSession(forVideo asset: PHAsset, options: PHVideoRequestOptions?, exportPreset: String, resultHandler: @escaping (AVAssetExportSession?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return mockRequestID
    }

    func requestAVAsset(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        resultHandler(avAssetToReturn, nil, infoToReturn)
        return mockRequestID
    }
}
