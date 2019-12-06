//
//  MockPhotoLibrary.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPhotoLibrary: PHPhotoLibrary {
    var performChangesSuccess: Bool = false
    var performChangesError: Error?

    override class func shared() -> PHPhotoLibrary {
        MockPhotoLibrary()
    }

    override func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        completionHandler?(performChangesSuccess, performChangesError)
    }
}
