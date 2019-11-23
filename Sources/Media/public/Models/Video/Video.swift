//
//  Video.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import Photos

public struct Video: AbstractMedia {
    public let phAsset: PHAsset

    public let type: MediaType = .video

    init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

public extension Video {
    var subtypes: [VideoSubtype] {
        var types: [VideoSubtype] = []

        switch phAsset.mediaSubtypes {
        case [.videoHighFrameRate, .videoStreamed, .videoTimelapse]:
            types.append(contentsOf: [.highFrameRate, .streamed, .timelapse])

        case [.videoHighFrameRate, .videoStreamed]:
            types.append(contentsOf: [.highFrameRate, .streamed])
        case [.videoStreamed, .videoTimelapse]:
            types.append(contentsOf: [.streamed, .timelapse])

        case [.videoHighFrameRate]:
            types.append(.highFrameRate)
        case [.videoStreamed]:
            types.append(.streamed)
        case [.videoTimelapse]:
            types.append(.timelapse)
        default: ()
        }

        return types
    }
}

public extension Video {
    func playerItem(_ completion: @escaping (Result<AVPlayerItem, Error>) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestPlayerItem(forVideo: phAsset, options: options) { playerItem, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let playerItem = playerItem {
                completion(.success(playerItem))
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }
}

public extension Video {
    static func with(identifier: String) -> Video? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier, MediaType.video.rawValue)
        options.predicate = predicate

        var video: Video?
        let result = PHAsset.fetchAssets(with: options)
        result.enumerateObjects { asset, _, stop in
            if asset.localIdentifier == identifier && asset.mediaType == .video {
                video = Video(phAsset: asset)
                stop.pointee = true
            }
        }
        return video
    }
}

public extension Video {
    // TODO:
    func edit(_ change: @escaping (inout PHContentEditingInput?) -> Void, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        let options = PHContentEditingInputRequestOptions()
        let contentEditingInputRequestID = phAsset.requestContentEditingInput(with: options) { contentEditingInput, info in
            var contentEditingInput = contentEditingInput
            change(&contentEditingInput)

            if let editingInput = contentEditingInput {
                let output = PHContentEditingOutput(contentEditingInput: editingInput)

                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest(for: self.phAsset)
                    assetChangeRequest.contentEditingOutput = output
                }) { isSuccess, error in
                    if !isSuccess {
                        completion(.failure(error ?? PhotosError.unknown))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }

        return {
            self.phAsset.cancelContentEditingInputRequest(contentEditingInputRequestID)
        }
    }
}
