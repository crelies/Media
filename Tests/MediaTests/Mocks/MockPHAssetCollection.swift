//
//  MockPHAssetCollection.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPHAssetCollection: PHAssetCollection {
    static var fetchResult = MockPHAssetCollectionFetchResult()

    override class func fetchAssetCollections(with type: PHAssetCollectionType,
                                              subtype: PHAssetCollectionSubtype,
                                              options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        fetchResult
    }
}
