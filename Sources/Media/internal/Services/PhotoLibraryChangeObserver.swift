//
//  PhotoLibraryChangeObserver.swift
//  Media
//
//  Created by Christian Elies on 27.01.20.
//

import Photos

final class PhotoLibraryChangeObserver: NSObject {
    private let asset: PHAsset
    private let completion: ResultPHAssetCompletion

    init(asset: PHAsset, _ completion: @escaping ResultPHAssetCompletion) {
        self.asset = asset
        self.completion = completion
    }
}

extension PhotoLibraryChangeObserver: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        let changeDetails = changeInstance.changeDetails(for: asset)

        DispatchQueue.main.async {
            guard let updatedAsset = changeDetails?.objectAfterChanges else {
                self.completion(.failure(Media.Error.unknown))
                return
            }
            self.completion(.success(updatedAsset))
        }
    }
}
