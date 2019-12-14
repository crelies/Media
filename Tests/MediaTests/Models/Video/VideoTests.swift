//
//  VideoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import XCTest

final class VideoTests: XCTestCase {
    let mockAsset = MockPHAsset()
    lazy var video = Video(phAsset: mockAsset)

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        PHAssetChanger.photoLibrary = MockPhotoLibrary()

        MockPHAsset.fetchResult.mockAssets.removeAll()

        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil

        mockAsset.localIdentifierToReturn = ""
        mockAsset.mediaTypeToReturn = .image
    }

    func testWithIdentifierExists() {
        let localIdentifier = "TestIdentifier"
        mockAsset.localIdentifierToReturn = localIdentifier
        mockAsset.mediaTypeToReturn = .video
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let video = Video.with(identifier: .init(stringLiteral: localIdentifier))
        XCTAssertNotNil(video)
    }

    func testWithIdentifierNotExists() {
        let video = Video.with(identifier: .init(stringLiteral: "Bloal"))
        XCTAssertNil(video)
    }

    func testFavoriteSuccess() {
        let expectation = self.expectation(description: "VideoFavoriteResult")

        let isFavorite = true
        var result: Result<Void, Error>?
        video.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid video favorite result")
        }
    }

    func testFavoriteFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        let expectation = self.expectation(description: "VideoFavoriteResult")

        let isFavorite = true
        var result: Result<Void, Error>?
        video.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid video favorite result")
        }
    }
}
