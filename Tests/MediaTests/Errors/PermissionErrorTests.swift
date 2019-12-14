//
//  PermissionErrorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import XCTest

final class PermissionErrorTests: XCTestCase {
    func testDeniedDescription() {
        let permissionError: PermissionError = .denied
        let expectedDescription = "The user has explicitly denied your app access to the photo library."
        XCTAssertEqual(permissionError.localizedDescription, expectedDescription)
    }

    func testNotDeterminedDescription() {
        let permissionError: PermissionError = .notDetermined
        let expectedDescription = "Explicit user permission is required for photo library access, but the user has not yet granted or denied such permission."
        XCTAssertEqual(permissionError.localizedDescription, expectedDescription)
    }

    func testRestrictedDescription() {
        let permissionError: PermissionError = .restricted
        let expectedDescription = "Your app is not authorized to access the photo library, and the user cannot grant such permission."
        XCTAssertEqual(permissionError.localizedDescription, expectedDescription)
    }

    func testUnknownDescription() {
        let permissionError: PermissionError = .unknown
        XCTAssertNil(permissionError.errorDescription)
    }
}
