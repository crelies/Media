//
//  PHChanger.swift
//  MediaCore
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

struct PHChanger {
    static var photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()

    static func request(
        _ request: @escaping () -> PHAssetCollectionChangeRequest?,
        _ completion: @escaping ResultVoidCompletion
    ) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        photoLibrary.performChanges({
            _ = request()
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? Media.Error.unknown))
            } else {
                completion(.success(()))
            }
        })
    }

    static func request(
        _ request: @escaping () -> PHAssetCollectionChangeRequest?
    ) async throws {
        try await withCheckedThrowingContinuation({ continuation in
            Self.request(request) { result in
                switch result {
                case .success:
                    continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
