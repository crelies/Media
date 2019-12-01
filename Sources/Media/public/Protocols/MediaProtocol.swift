//
//  MediaProtocol.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public protocol MediaProtocol {
    var phAsset: PHAsset { get }
    var identifier: String { get }
    var type: MediaType { get }

    init(phAsset: PHAsset)

    static func with(identifier: String) -> Self?
    func delete(completion: @escaping (Result<Void, Error>) -> Void)
}

extension MediaProtocol {
    public var identifier: String { phAsset.localIdentifier }

    public func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let phAssets: NSArray = [self.phAsset]
            PHAssetChangeRequest.deleteAssets(phAssets)
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                completion(.success(()))
            }
        })
    }
}
