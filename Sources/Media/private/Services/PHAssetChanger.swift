//
//  PHAssetChanger.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

@available(macOS 10.15, *)
struct PHAssetChanger {
    // TODO: unavailabilityReason
    static var photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()

    static func createRequest<T: MediaProtocol>(_ request: @escaping () -> AssetChangeRequest?,
                                                _ completion: @escaping (Result<T, Error>) -> Void) {
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
                completion(.failure(error ?? MediaError.unknown))
            } else {
                do {
                    if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let item = try T.with(identifier: Media.Identifier(stringLiteral: localIdentifier)) {
                        completion(.success(item))
                    } else {
                        completion(.failure(MediaError.unknown))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        })
    }

    static func favorite(phAsset: PHAsset, favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        photoLibrary.performChanges({
            let assetChangeRequest = PHAssetChangeRequest(for: phAsset)
            assetChangeRequest.isFavorite = favorite
        }) { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? MediaError.unknown))
            } else {
                completion(.success(()))
            }
        }
    }
}
