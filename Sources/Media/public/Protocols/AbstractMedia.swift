//
//  AbstractMedia.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import Photos

public protocol AbstractMedia {
    var phAsset: PHAsset { get }
    var identifier: String { get }
    var type: MediaType { get }

    func delete(completion: @escaping (Result<Void, Error>) -> Void)
}

extension AbstractMedia {
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
