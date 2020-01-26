//
//  VideoManager.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

import Photos

typealias RequestPlayerItemResultHandler = (AVPlayerItem?, [AnyHashable : Any]?) -> Void
typealias RequestExportSessionResultHandler = (AVAssetExportSession?, [AnyHashable : Any]?) -> Void
typealias RequestAVAssetResultHandler = (AVAsset?, AVAudioMix?, [AnyHashable : Any]?) -> Void

protocol VideoManager {
    @discardableResult
    func requestPlayerItem(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping RequestPlayerItemResultHandler) -> PHImageRequestID

    @discardableResult
    func requestExportSession(forVideo asset: PHAsset, options: PHVideoRequestOptions?, exportPreset: String, resultHandler: @escaping RequestExportSessionResultHandler) -> PHImageRequestID

    @discardableResult
    func requestAVAsset(forVideo asset: PHAsset, options: PHVideoRequestOptions?, resultHandler: @escaping RequestAVAssetResultHandler) -> PHImageRequestID
}
