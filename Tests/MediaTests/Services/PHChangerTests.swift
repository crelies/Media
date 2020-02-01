//
//  PHChangerTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import Media
import XCTest

final class PHChangerTests: XCTestCase {
    override func setUp() {
        PHChanger.photoLibrary = MockPhotoLibrary()
        Media.photoLibrary = MockPhotoLibrary.self

        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequestWithoutPermission() {
        MockPhotoLibrary.authorizationStatusToReturn = .denied

        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<Void, Error>?
        PHChanger.request({ nil }) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertNotNil(result)

        switch result {
        case .success:
            XCTFail("Invalid result")
        case .failure(let error):
            let permissionError = error as? PermissionError
            XCTAssertEqual(permissionError, PermissionError.denied)
        default: ()
        }
    }

    func testRequestWithError() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<Void, Error>?
        PHChanger.request({ nil }) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertNotNil(result)

        switch result {
        case .success:
            XCTFail("Invalid result")
        case .failure(let error):
            let mediaError = error as? Media.Error
            XCTAssertEqual(mediaError, Media.Error.unknown)
        default: ()
        }
    }

    func testRequestWithSuccess() {
        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<Void, Error>?
        PHChanger.request({ nil }) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssertNotNil(result)

        switch result {
        case .success: ()
        case .failure:
            XCTFail("Invalid result")
        case .none:
            XCTFail("Missing result")
        }
    }
}
