//
//  PHAssetFetcher.swift
//  
//
//  Created by Christian Elies on 30.11.19.
//

import Photos

struct PHAssetFetcher {
    static func fetchAssets<T: AbstractMedia>(_ type: T.Type,
                                              options: PHFetchOptions) -> [T] {
        let result = PHAsset.fetchAssets(with: options)

        var items: [T] = []
        result.enumerateObjects { asset, _, _ in
            let item = type.init(phAsset: asset)
            items.append(item)
        }
        return items
    }

    static func fetchAssets<T: AbstractMedia>(ofType type: T.Type, in assetCollection: PHAssetCollection, options: PHFetchOptions) -> [T] {
        let result = PHAsset.fetchAssets(in: assetCollection, options: options)

        var items: [T] = []
        result.enumerateObjects { asset, _, _ in
            let item = type.init(phAsset: asset)
            items.append(item)
        }
        return items
    }

    static func fetchAsset<T: AbstractMedia>(_ type: T.Type,
                                             options: PHFetchOptions,
                                             filter: @escaping (PHAsset) -> Bool = { _ in true }) -> T? {
        let result = PHAsset.fetchAssets(with: options)

        var item: T?
        result.enumerateObjects { asset, _, stop in
            if filter(asset) {
                item = type.init(phAsset: asset)
                stop.pointee = true
            }
        }
        return item
    }
}
