//
//  MediaTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

@testable import MediaCore
import XCTest

final class MediaTests: XCTestCase {
    override func setUp() {
        Media.photoLibrary = MockPhotoLibrary.self

        MockPhotoLibrary.authorizationStatusToReturn = .denied
    }

    func testPermissionAuthorized() {
        MockPhotoLibrary.authorizationStatusToReturn = .authorized

        Media.requestPermission { result in
            switch result {
            case .success: ()
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
    }

    func testPermissionDenied() {
        MockPhotoLibrary.authorizationStatusToReturn = .denied

        Media.requestPermission { result in
            switch result {
            case .success: ()
            case .failure(let error):
                XCTAssertEqual(error, .denied)
            }
        }
    }

    func testPermissionRestricted() {
        MockPhotoLibrary.authorizationStatusToReturn = .restricted

        Media.requestPermission { result in
            switch result {
            case .success: ()
            case .failure(let error):
                XCTAssertEqual(error, .restricted)
            }
        }
    }

    func testPermissionNotDetermined() {
        MockPhotoLibrary.authorizationStatusToReturn = .notDetermined

        Media.requestPermission { result in
            switch result {
            case .success: ()
            case .failure(let error):
                XCTAssertEqual(error, .notDetermined)
            }
        }
    }
}
