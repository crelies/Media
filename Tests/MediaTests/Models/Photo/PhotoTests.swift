//
//  PhotoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

@testable import Media
import XCTest

final class PhotoTests: XCTestCase {
    let mockAsset = MockPHAsset()
    lazy var photo = Photo(phAsset: mockAsset)
    let mockPHObjectPlaceholder = MockPHObjectPlaceholder()

    override func setUp() {
        PHAssetChanger.photoLibrary = MockPhotoLibrary()
        Media.photoLibrary = MockPhotoLibrary.self
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
        Photo.assetChangeRequest = MockPHAssetChangeRequest.self
        mockPHObjectPlaceholder.localIdentifierToReturn = ""
        MockPHAssetChangeRequest.placeholderForCreatedAssetToReturn = mockPHObjectPlaceholder
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.localIdentifierToReturn = ""
        mockAsset.mediaTypeToReturn = .unknown
    }

    @available(iOS 11, *)
    func testSaveURLSuccess() {
        let localIdentifier = UUID().uuidString
        mockAsset.localIdentifierToReturn = localIdentifier
        mockAsset.mediaTypeToReturn = .image
        MockPHAsset.fetchResult.mockAssets = [mockAsset]

        mockPHObjectPlaceholder.localIdentifierToReturn = localIdentifier

        let expectation = self.expectation(description: "SaveURLResult")

        do {
            let url = URL(fileURLWithPath: "file://test.\(Photo.FileType.jpg.pathExtensions.first!)")
            let mediaURL: MediaURL<Photo> = try MediaURL(url: url)

            var result: Result<Photo, Error>?
            Photo.save(mediaURL, { res in
                result = res
                expectation.fulfill()
            })

            waitForExpectations(timeout: 1)

            switch result {
            case .success: ()
            default: ()
                // TODO:
//                XCTFail("Invalid photo save URL result")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testSaveURLFailure() {

    }

    func testSaveUIImageSuccess() {

    }

    func testSaveUIImageFailure() {

    }

    func testFavoriteSuccess() {

    }

    func testFavoriteFailure() {

    }
}
