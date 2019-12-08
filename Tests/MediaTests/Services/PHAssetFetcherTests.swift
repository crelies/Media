//
//  PHAssetFetcherTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import Media
import Photos
import XCTest

@available(macOS 10.15, *)
final class PHAssetFetcherTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAudiosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let options = PHFetchOptions()
        let audios = PHAssetFetcher.fetchAssets(options: options) as [Audio]
        XCTAssertEqual(audios.count, 1)
    }

    func testFetchAudiosEmpty() {
        let options = PHFetchOptions()
        let audios = PHAssetFetcher.fetchAssets(options: options) as [Audio]
        XCTAssertEqual(audios.count, 0)
    }

    func testFetchLivePhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let options = PHFetchOptions()
        let livePhotos = PHAssetFetcher.fetchAssets(options: options) as [LivePhoto]
        XCTAssertEqual(livePhotos.count, 1)
    }

    func testFetchLivePhotosEmpty() {
        let options = PHFetchOptions()
        let livePhotos = PHAssetFetcher.fetchAssets(options: options) as [LivePhoto]
        XCTAssertEqual(livePhotos.count, 0)
    }

    func testFetchPhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let options = PHFetchOptions()
        let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
        XCTAssertEqual(photos.count, 1)
    }

    func testFetchPhotosEmpty() {
        let options = PHFetchOptions()
        let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
        XCTAssertEqual(photos.count, 0)
    }

    func testFetchVideosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let options = PHFetchOptions()
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        XCTAssertEqual(videos.count, 1)
    }

    func testFetchVideosEmpty() {
        let options = PHFetchOptions()
        let videos = PHAssetFetcher.fetchAssets(options: options) as [Video]
        XCTAssertEqual(videos.count, 0)
    }
}
