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

    // TODO: osx 10.13
    @available(macOS 10.15, *)
    static func with(identifier: String) -> Self?

    // TODO: osx 10.13
    @available(macOS 10.15, *)
    func delete(completion: @escaping (Result<Void, Error>) -> Void)
}

extension MediaProtocol {
    public var identifier: String { phAsset.localIdentifier }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
extension MediaProtocol {
    public func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHChanger.request({
            let phAssets: NSArray = [self.phAsset]
            PHAssetChangeRequest.deleteAssets(phAssets)
            return nil
        }, completion)
    }
}
