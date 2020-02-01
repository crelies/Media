//
//  MockPhotoLibraryChangeObserver.swift
//  MediaTests
//
//  Created by Christian Elies on 01.02.20.
//

@testable import Media
import Photos

final class MockPhotoLibraryChangeObserver: NSObject, PhotoLibraryChangeObserver {
    private let asset: PHAsset
    private let completion: ResultPHAssetCompletion

    init(asset: PHAsset, _ completion: @escaping ResultPHAssetCompletion) {
        self.asset = asset
        self.completion = completion
    }
}

extension MockPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        let updatedAsset = MockPHAsset()
        updatedAsset.isFavoriteToReturn = !asset.isFavorite
        completion(.success(updatedAsset))
    }
}
