//
//  AlbumTests.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

@testable import Media
import XCTest

final class AlbumTests: XCTestCase {
    let mockAssetCollection = MockPHAssetCollection()
    lazy var album = Album(phAssetCollection: mockAssetCollection)

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    func testAudiosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.audios
        XCTAssertFalse(items.isEmpty)
    }

    func testAudiosEmpty() {
        let items = album.audios
        XCTAssertTrue(items.isEmpty)
    }

    func testPhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.photos
        XCTAssertFalse(items.isEmpty)
    }

    func testPhotosEmpty() {
        let items = album.photos
        XCTAssertTrue(items.isEmpty)
    }

    func testVideosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.videos
        XCTAssertFalse(items.isEmpty)
    }

    func testVideosEmpty() {
        let items = album.videos
        XCTAssertTrue(items.isEmpty)
    }

    func testLivePhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.livePhotos
        XCTAssertFalse(items.isEmpty)
    }

    func testLivePhotosEmpty() {
        let items = album.livePhotos
        XCTAssertTrue(items.isEmpty)
    }
}
