//
//  PHAssetChanger.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct PHAssetChanger {
    static var photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()

    static func createRequest<T: MediaProtocol>(_ request: @escaping () -> AssetChangeRequest?,
                                                _ completion: @escaping ResultGenericCompletion<T>) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        var placeholderForCreatedAsset: PHObjectPlaceholder?
        photoLibrary.performChanges({
            let creationRequest = request()
            if let placeholder = creationRequest?.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? Media.Error.unknown))
            } else {
                do {
                    if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let item = try T.with(identifier: Media.Identifier(stringLiteral: localIdentifier)) {
                        completion(.success(item))
                    } else {
                        completion(.failure(Media.Error.unknown))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        })
    }

    static func favorite(phAsset: PHAsset, favorite: Bool, _ completion: @escaping ResultVoidCompletion) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        photoLibrary.performChanges({
            let assetChangeRequest = PHAssetChangeRequest(for: phAsset)
            assetChangeRequest.isFavorite = favorite
        }) { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? Media.Error.unknown))
            } else {
                completion(.success(()))
            }
        }
    }
}
