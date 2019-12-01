//
//  PHAssetFetcher.swift
//  
//
//  Created by Christian Elies on 30.11.19.
//

import Photos

struct PHAssetFetcher {
    static func fetchAssets<T: MediaProtocol>(options: PHFetchOptions) -> [T] {
        let result = PHAsset.fetchAssets(with: options)

        var items: [T] = []
        result.enumerateObjects { asset, _, _ in
            let item = T.init(phAsset: asset)
            items.append(item)
        }
        return items
    }

    static func fetchAssets<T: MediaProtocol>(in assetCollection: PHAssetCollection, options: PHFetchOptions) -> [T] {
        let result = PHAsset.fetchAssets(in: assetCollection, options: options)

        var items: [T] = []
        result.enumerateObjects { asset, _, _ in
            let item = T.init(phAsset: asset)
            items.append(item)
        }
        return items
    }

    static func fetchAsset<T: MediaProtocol>(options: PHFetchOptions,
                                             filter: @escaping (PHAsset) -> Bool = { _ in true }) -> T? {
        let result = PHAsset.fetchAssets(with: options)

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
