//
//  PHAsset+anyMediaTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import MediaCore
import Photos
import XCTest

final class PHAsset_anyMediaTests: XCTestCase {
    func testAudioAnyMedia() {
        let asset = MockPHAsset()
        asset.mediaTypeToReturn = .audio
        XCTAssertNotNil(asset.anyMedia?.value as? Audio)
    }

    func testLivePhotoAnyMedia() {
        let asset = MockPHAsset()
        asset.mediaTypeToReturn = .image
        asset.mediaSubtypesToReturn = .photoLive
        XCTAssertNotNil(asset.anyMedia?.value as? LivePhoto)
    }

    func testPhotoAnyMedia() {
        let asset = MockPHAsset()
        asset.mediaTypeToReturn = .image
        XCTAssertNotNil(asset.anyMedia?.value as? Photo)
    }

    func testVideoAnyMedia() {
        let asset = MockPHAsset()
        asset.mediaTypeToReturn = .video
        XCTAssertNotNil(asset.anyMedia?.value as? Video)
    }

    func testUnknownAnyMedia() {
        let asset = MockPHAsset()
        asset.mediaTypeToReturn = .unknown
        XCTAssertNil(asset.anyMedia)
    }
}
