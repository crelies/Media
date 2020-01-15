//
//  PHAssetChangerTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import Media
import Photos
import XCTest

final class PHAssetChangerTests: XCTestCase {
    override func setUp() {
        Media.photoLibrary = MockPhotoLibrary.self
        PHAssetChanger.photoLibrary = MockPhotoLibrary()

        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavoriteWithoutPermission() {
        MockPhotoLibrary.authorizationStatusToReturn = .denied

        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<Void, Error>?
        PHAssetChanger.favorite(phAsset: PHAsset(), favorite: false) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertNotNil(result)

        switch result {
        case .failure(let error):
            let permissionError = error as? PermissionError
            XCTAssertEqual(permissionError, PermissionError.denied)
        default:
            XCTFail()
        }
    }

    func testFavoriteWithError() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<Void, Error>?
        PHAssetChanger.favorite(phAsset: PHAsset(), favorite: false) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertNotNil(result)

        switch result {
        case .failure(let error):
            let mediaError = error as? MediaError
            XCTAssertEqual(mediaError, MediaError.unknown)
        default:
            XCTFail("Invalid result \(String(describing: result))")
        }
    }

    func testFavoriteWithSuccess() {
        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<Void, Error>?
        PHAssetChanger.favorite(phAsset: PHAsset(), favorite: false) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertNotNil(result)

        switch result {
        case .success: ()
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .none:
            XCTFail("Invalid result \(String(describing: result))")
        }
    }
}
