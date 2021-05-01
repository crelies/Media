@testable import MediaCore
import XCTest

final class LazyPhotosTests: XCTestCase {
    let mockAsset = MockPHAsset()

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.mediaTypeToReturn = .image
        mockAsset.mediaSubtypesToReturn = []
        Media.photoLibrary = MockPhotoLibrary.self
        PHChanger.photoLibrary = MockPhotoLibrary()
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
    }

    func testAllEmpty() {
        let photos = Media.LazyPhotos.all
        XCTAssertEqual(photos?.count, 0)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.LazyPhotos.all
        XCTAssertEqual(photos?.count, 1)
    }

    func testLiveEmpty() {
        let photos = Media.LazyPhotos.live
        XCTAssertEqual(photos?.count, 0)
    }

    func testLiveNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoLive]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.LazyPhotos.live
        XCTAssertEqual(photos?.count, 1)
    }

    func testPanoramaEmpty() {
        let photos = Media.LazyPhotos.panorama
        XCTAssertEqual(photos?.count, 0)
    }

    func testPanoramaNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoPanorama]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.LazyPhotos.panorama
        XCTAssertEqual(photos?.count, 1)
    }

    func testHDREmpty() {
        let photos = Media.LazyPhotos.hdr
        XCTAssertEqual(photos?.count, 0)
    }

    func testHDRNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoHDR]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.LazyPhotos.hdr
        XCTAssertEqual(photos?.count, 1)
    }

    func testScreenshotEmpty() {
        let photos = Media.LazyPhotos.screenshot
        XCTAssertEqual(photos?.count, 0)
    }

    func testScreenshotNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoScreenshot]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.LazyPhotos.screenshot
        XCTAssertEqual(photos?.count, 1)
    }

    @available(iOS 10.2, *)
    @available(tvOS 10.1, *)
    func testDepthEffectEmpty() {
        let photos = Media.LazyPhotos.depthEffect
        XCTAssertEqual(photos?.count, 0)
    }

    @available(iOS 10.2, *)
    @available(tvOS 10.1, *)
    func testDepthEffectNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.photoDepthEffect]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let photos = Media.LazyPhotos.depthEffect
        XCTAssertEqual(photos?.count, 1)
    }
}
