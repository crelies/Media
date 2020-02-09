//
//  MockPHChange.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

import Photos

final class MockPHChange: PHChange {
    var changeDetailsToReturn: PHObjectChangeDetails<PHObject>?

    override func __changeDetails(for object: PHObject) -> PHObjectChangeDetails<PHObject>? {
        changeDetailsToReturn
    }
}
