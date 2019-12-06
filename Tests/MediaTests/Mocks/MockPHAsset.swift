//
//  MockPHAsset.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPHAsset: PHAsset {
    static var fetchResult = MockPHAssetsFetchResult()

    override class func fetchAssets(with options: PHFetchOptions?) -> PHFetchResult<PHAsset> {
        fetchResult
    }
}
