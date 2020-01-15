//
//  PhotosTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import Media
import XCTest

final class PhotosTests: XCTestCase {
    let mockAsset = MockPHAsset()

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.mediaTypeToReturn = .image
        mockAsset.mediaSubtypesToReturn = []
    }

    func testAllEmpty() {
        let photos = Media.Photos.all
        XCTAssertTrue(photos.isEmpty)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.Photos.all
        XCTAssertFalse(photos.isEmpty)
    }

    func testLiveEmpty() {
        let photos = Media.Photos.live
        XCTAssertTrue(photos.isEmpty)
    }

    func testLiveNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoLive]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.Photos.live
        XCTAssertFalse(photos.isEmpty)
    }

    func testPanoramaEmpty() {
        let photos = Media.Photos.panorama
        XCTAssertTrue(photos.isEmpty)
    }

    func testPanoramaNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoPanorama]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.Photos.panorama
        XCTAssertFalse(photos.isEmpty)
    }

    func testHDREmpty() {
        let photos = Media.Photos.hdr
        XCTAssertTrue(photos.isEmpty)
    }

    func testHDRNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoHDR]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.Photos.hdr
        XCTAssertFalse(photos.isEmpty)
    }

    func testScreenshotEmpty() {
        let photos = Media.Photos.screenshot
        XCTAssertTrue(photos.isEmpty)
    }

    func testScreenshotNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoScreenshot]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.Photos.screenshot
        XCTAssertFalse(photos.isEmpty)
    }

    @available(iOS 10.2, *)
    @available(tvOS 10.1, *)
    func testDepthEffectEmpty() {
        let photos = Media.Photos.depthEffect
        XCTAssertTrue(photos.isEmpty)
    }

    @available(iOS 10.2, *)
    @available(tvOS 10.1, *)
    func testDepthEffectNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoDepthEffect]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.Photos.depthEffect
        XCTAssertFalse(photos.isEmpty)
    }
}
