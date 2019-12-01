//
//  PHAssetChanger.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct PHAssetChanger {
    static func favorite(phAsset: PHAsset, favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest(for: phAsset)
            assetChangeRequest.isFavorite = favorite
        }) { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        }
    }
}
