//
//  MockPHAssetsFetchResult.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPHAssetsFetchResult: PHFetchResult<PHAsset> {
    var mockAssets = [MockPHAsset]()

    override var count: Int { mockAssets.count }

    override func enumerateObjects(_ block: @escaping (PHAsset, Int, UnsafeMutablePointer<ObjCBool>) -> Void) {
        var stop: ObjCBool = false
        for (index, mockAsset) in mockAssets.enumerated() {
            if stop.boolValue {
                break
            }
            block(mockAsset, index, &stop)
        }
    }
}
