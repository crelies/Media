//
//  CustomPhotoLibraryChangeObserverTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

@testable import MediaCore
import Photos
import XCTest

final class CustomPhotoLibraryChangeObserverTests: XCTestCase {
    let asset = MockPHAsset()

    func testPhotoLibraryDidChangeSuccess() {
        let expectation = self.expectation(description: "Result")

        var result: Result<PHAsset, Error>?
        let observer = CustomPhotoLibraryChangeObserver(asset: asset) { res in
            result = res
            expectation.fulfill()
        }

        let change = MockPHChange()
        let changeDetails = MockPHObjectChangeDetails()
        changeDetails.objectAfterChangesToReturn = asset
        change.changeDetailsToReturn = changeDetails

        observer.photoLibraryDidChange(change)

        waitForExpectations(timeout: 1)

        switch result {
        case .success(let updatedAsset):
            XCTAssertEqual(updatedAsset.localIdentifier, asset.localIdentifier)
        default:
            XCTFail("Unexpected result: \(String(describing: result))")
        }
    }

    func testPhotoLibraryDidChangeFailure() {
        let expectation = self.expectation(description: "Result")

        var result: Result<PHAsset, Error>?
        let observer = CustomPhotoLibraryChangeObserver(asset: asset) { res in
            result = res
            expectation.fulfill()
        }

        observer.photoLibraryDidChange(PHChange())

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Unexpected result: \(String(describing: result))")
        }
    }
}
