//
//  MockPHAssetCollectionFetchResult.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPHAssetCollectionFetchResult: PHFetchResult<PHAssetCollection> {
    var mockAssetCollections = [MockPHAssetCollection]()

    override func enumerateObjects(_ block: @escaping (PHAssetCollection, Int, UnsafeMutablePointer<ObjCBool>) -> Void) {
        var stop: ObjCBool = false
        for (index, mockAssetCollection) in mockAssetCollections.enumerated() {
            if stop.boolValue {
                break
            }
            block(mockAssetCollection, index, &stop)
        }
    }
}
