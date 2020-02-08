//
//  PHAssetFetcherTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import MediaCore
import Photos
import XCTest

final class PHAssetFetcherTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    func testFetchAudiosNotEmpty() {
        do {
            MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
            let options = PHFetchOptions()
            let audios = try PHAssetFetcher.fetchAssets(options: options) as [Audio]
            XCTAssertEqual(audios.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchAudiosEmpty() {
        do {
            let options = PHFetchOptions()
            let audios = try PHAssetFetcher.fetchAssets(options: options) as [Audio]
            XCTAssertEqual(audios.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchLivePhotosNotEmpty() {
        do {
            MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
            let options = PHFetchOptions()
            let livePhotos = try PHAssetFetcher.fetchAssets(options: options) as [LivePhoto]
            XCTAssertEqual(livePhotos.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchLivePhotosEmpty() {
        do {
            let options = PHFetchOptions()
            let livePhotos = try PHAssetFetcher.fetchAssets(options: options) as [LivePhoto]
            XCTAssertEqual(livePhotos.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchPhotosNotEmpty() {
        do {
            MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
            let options = PHFetchOptions()
            let photos = try PHAssetFetcher.fetchAssets(options: options) as [Photo]
            XCTAssertEqual(photos.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchPhotosEmpty() {
        do {
            let options = PHFetchOptions()
            let photos = try PHAssetFetcher.fetchAssets(options: options) as [Photo]
            XCTAssertEqual(photos.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchVideosNotEmpty() {
        do {
            MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
            let options = PHFetchOptions()
            let videos = try PHAssetFetcher.fetchAssets(options: options) as [Video]
            XCTAssertEqual(videos.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchVideosEmpty() {
        do {
            let options = PHFetchOptions()
            let videos = try PHAssetFetcher.fetchAssets(options: options) as [Video]
            XCTAssertEqual(videos.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
