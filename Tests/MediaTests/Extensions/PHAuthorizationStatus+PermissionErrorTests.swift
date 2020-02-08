//
//  PHAuthorizationStatus+PermissionErrorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import MediaCore
import Photos
import XCTest

final class PHAuthorizationStatus_PermissionErrorTests: XCTestCase {
    func testDenied() {
        let authorizationStatus: PHAuthorizationStatus = .denied
        XCTAssertEqual(authorizationStatus.permissionError, .denied)
    }

    func testNotDetermined() {
        let authorizationStatus: PHAuthorizationStatus = .notDetermined
        XCTAssertEqual(authorizationStatus.permissionError, .notDetermined)
    }

    func testRestricted() {
        let authorizationStatus: PHAuthorizationStatus = .restricted
        XCTAssertEqual(authorizationStatus.permissionError, .restricted)
    }

    func testAuthorized() {
        let authorizationStatus: PHAuthorizationStatus = .authorized
        XCTAssertNil(authorizationStatus.permissionError)
    }
}
