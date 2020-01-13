//
//  VideoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

import AVFoundation
@testable import Media
import Photos
import XCTest

@available(macOS 10.15, *)
final class VideoTests: XCTestCase {
    let videoManager = MockVideoManager()
    let mockAsset = MockPHAsset()
    lazy var video = Video(phAsset: mockAsset)

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        PHAssetChanger.photoLibrary = MockPhotoLibrary()

        Video.videoManager = videoManager
        videoManager.avPlayerItemToReturn = nil
        videoManager.avAssetToReturn = nil
        videoManager.infoToReturn = nil

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

    func testPlayerItemSuccess() {
        guard let pathExtension = Video.FileType.mov.pathExtensions.first else {
            XCTFail("Could not fetch mov path extension")
            return
        }

        guard let url = URL(string: "file://test.\(pathExtension)") else {
            XCTFail("Could not create URL")
            return
        }

        videoManager.avPlayerItemToReturn = AVPlayerItem(url: url)

        let expectation = self.expectation(description: "PlayerItemResult")
        var result: Result<AVPlayerItem, Error>?
        video.playerItem { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid player item result")
        }
    }

    func testPlayerItemFailure() {
        videoManager.infoToReturn = [PHImageErrorKey: MediaError.unknown]

        let expectation = self.expectation(description: "PlayerItemResult")
        var result: Result<AVPlayerItem, Error>?
        video.playerItem { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid player item result")
        }
    }

    func testAVAssetSuccess() {
        guard let pathExtension = Video.FileType.mov.pathExtensions.first else {
            XCTFail("Could not fetch mov path extension")
            return
        }

        guard let url = URL(string: "file://test.\(pathExtension)") else {
            XCTFail("Could not create URL")
            return
        }

        videoManager.avAssetToReturn = AVAsset(url: url)

        let expectation = self.expectation(description: "AVAssetResult")
        var result: Result<AVAsset, Error>?
        video.avAsset { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid av asset result")
        }
    }

    func testAVAssetFailure() {
        videoManager.infoToReturn = [PHImageErrorKey: MediaError.unknown]

        let expectation = self.expectation(description: "AVAssetResult")
        var result: Result<AVAsset, Error>?
        video.avAsset { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid av asset result")
        }
    }
}
