//
//  MockPhotoLibrary.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import MediaCore
import Photos

final class MockPhotoLibrary: PhotoLibrary {
    private weak var observer: PHPhotoLibraryChangeObserver?

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

    @available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *)
    static func requestAuthorization(for accessLevel: PHAccessLevel, handler: @escaping RequestAuthorizationHandler) {
        handler(authorizationStatusToReturn)
    }

    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        completionHandler?(Self.performChangesSuccess, Self.performChangesError)
        observer.map { $0.photoLibraryDidChange(PHChange()) }
    }

    func register(_ observer: PHPhotoLibraryChangeObserver) {
        self.observer = observer
    }

    func unregisterChangeObserver(_ observer: PHPhotoLibraryChangeObserver) {
        self.observer = nil
    }
}
