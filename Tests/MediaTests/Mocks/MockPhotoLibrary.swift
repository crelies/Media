//
//  MockPhotoLibrary.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import Media
import Photos

final class MockPhotoLibrary: PhotoLibrary {
    static var authorizationStatusToReturn: PHAuthorizationStatus = .authorized
    static var performChangesSuccess: Bool = false
    static var performChangesError: Error?

    static func sharedInstance() -> PhotoLibrary {
        MockPhotoLibrary()
    }

    static func authorizationStatus() -> PHAuthorizationStatus {
        authorizationStatusToReturn
    }

    static func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
        handler(authorizationStatusToReturn)
    }

    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        completionHandler?(Self.performChangesSuccess, Self.performChangesError)
    }
}
