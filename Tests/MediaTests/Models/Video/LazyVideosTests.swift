@testable import MediaCore
import XCTest

final class LazyVideosTests: XCTestCase {
    let mockAsset = MockPHAsset()

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.mediaTypeToReturn = .video
        mockAsset.mediaSubtypesToReturn = []
        Media.photoLibrary = MockPhotoLibrary.self
        PHChanger.photoLibrary = MockPhotoLibrary()
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
    }

    func testAllEmpty() {
        let videos = LazyVideos.all
        XCTAssertEqual(videos?.count, 0)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = LazyVideos.all
        XCTAssertEqual(videos?.count, 1)
    }

    func testStreamsEmpty() {
        let videos = LazyVideos.streams
        XCTAssertEqual(videos?.count, 0)
    }

    func testStreamsNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.videoStreamed]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = LazyVideos.streams
        XCTAssertEqual(videos?.count, 1)
    }

    func testHighFrameRatesEmpty() {
        let videos = LazyVideos.highFrameRates
        XCTAssertEqual(videos?.count, 0)
    }

    func testHighFrameRatesNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.videoHighFrameRate]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = LazyVideos.highFrameRates
        XCTAssertEqual(videos?.count, 1)
    }

    func testTimelapsesEmpty() {
        let videos = LazyVideos.timelapses
        XCTAssertEqual(videos?.count, 0)
    }

    func testTimelapsesNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.videoTimelapse]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = LazyVideos.timelapses
        XCTAssertEqual(videos?.count, 1)
    }
}
