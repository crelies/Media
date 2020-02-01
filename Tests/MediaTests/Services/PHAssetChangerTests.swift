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
    let mockAsset = MockPHAsset()

    override func setUp() {
        Media.photoLibrary = MockPhotoLibrary.self
        PHAssetChanger.photoLibrary = MockPhotoLibrary()

        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
    }

    func testFavoriteWithoutPermission() {
        MockPhotoLibrary.authorizationStatusToReturn = .denied

        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<PHAsset, Error>?
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
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        let expectation = self.expectation(description: "RequestCompleted")

        var result: Result<PHAsset, Error>?
        PHAssetChanger.favorite(phAsset: PHAsset(), favorite: false) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertNotNil(result)

        switch result {
        case .failure(let error):
            let mediaError = error as? Media.Error
            XCTAssertEqual(mediaError, Media.Error.unknown)
        default:
            XCTFail("Invalid result \(String(describing: result))")
        }
    }

    func testFavoriteWithSuccess() {
        let expectation = self.expectation(description: "RequestCompleted")

        XCTAssertFalse(mockAsset.isFavorite)

        var result: Result<PHAsset, Error>?
        PHAssetChanger.favorite(phAsset: mockAsset, favorite: !mockAsset.isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)

        XCTAssertNotNil(result)

        switch result {
        case .success:
            do {
                guard let asset = try result?.get() else {
                    XCTFail("Missing asset in result")
                    return
                }
                XCTAssertTrue(asset.isFavorite)
            } catch {
                XCTFail(error.localizedDescription)
            }
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .none:
            XCTFail("Invalid result \(String(describing: result))")
        }
    }
}
