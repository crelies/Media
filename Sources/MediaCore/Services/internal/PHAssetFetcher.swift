//
//  PHAssetFetcher.swift
//  MediaCore
//
//  Created by Christian Elies on 30.11.19.
//

import Photos

struct PHAssetFetcher {
    static var asset: PHAsset.Type = PHAsset.self

    static func fetchAssets<T: MediaProtocol>(
        in assetCollection: PHAssetCollection,
        options: PHFetchOptions
    ) throws -> [T] {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        let result = asset.fetchAssets(in: assetCollection, options: options)

        var items: [T] = []
        result.enumerateObjects { asset, _, _ in
            let item = T.init(phAsset: asset)
            items.append(item)
        }
        return items
    }

    static func fetchAssets(
        in assetCollection: PHAssetCollection,
        options: PHFetchOptions
    ) throws -> PHFetchResult<PHAsset> {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        return asset.fetchAssets(in: assetCollection, options: options)
    }
}

extension PHAssetFetcher {
    static func fetchAssets<T: MediaProtocol>(
        options: PHFetchOptions
    ) throws -> [T] {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        let result = asset.fetchAssets(with: options)

        var items: [T] = []
        result.enumerateObjects { asset, _, _ in
            let item = T.init(phAsset: asset)
            items.append(item)
        }
        return items
    }

    static func fetchAssets(
        options: PHFetchOptions
    ) throws -> PHFetchResult<PHAsset> {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        return asset.fetchAssets(with: options)
    }

    static func fetchAsset<T: MediaProtocol>(
        options: PHFetchOptions,
        filter: @escaping (PHAsset) -> Bool = { _ in true }
    ) throws -> T? {
        guard Media.isAccessAllowed else {
            throw Media.currentPermission.permissionError ?? PermissionError.unknown
        }

        let result = asset.fetchAssets(with: options)

        var item: T?
        result.enumerateObjects { asset, _, stop in
            if filter(asset) {
                item = T.init(phAsset: asset)
                stop.pointee = true
            }
        }
        return item
    }
}
