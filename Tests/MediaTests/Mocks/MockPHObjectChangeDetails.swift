//
//  MockPHObjectChangeDetails.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

import Photos

final class MockPHObjectChangeDetails: PHObjectChangeDetails<PHObject> {
    var objectAfterChangesToReturn: PHObject?

    override var objectAfterChanges: PHObject? { objectAfterChangesToReturn }
}
