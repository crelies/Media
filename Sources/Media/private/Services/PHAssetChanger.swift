//
//  PHAssetChanger.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct PHAssetChanger {
    static func request<T: AbstractMedia>(request: @escaping () -> PHAssetChangeRequest?,
                                          forType type: T.Type,
                                          _ completion: @escaping (Result<T, Error>) -> Void) {
        var placeholderForCreatedAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = request()
            if let placeholder = creationRequest?.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let item = T.with(identifier: localIdentifier) {
                    completion(.success(item))
                } else {
                    completion(.failure(PhotosError.unknown))
                }
            }
        })
    }

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
