//
//  VideosTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import Media
import XCTest

@available(macOS 10.15, *)
final class VideosTests: XCTestCase {
    let mockAsset = MockPHAsset()

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.mediaTypeToReturn = .video
        mockAsset.mediaSubtypesToReturn = []
    }

    func testAllEmpty() {
        let videos = Videos.all
        XCTAssertTrue(videos.isEmpty)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = Videos.all
        XCTAssertFalse(videos.isEmpty)
    }

    func testStreamsEmpty() {
        let videos = Videos.streams
        XCTAssertTrue(videos.isEmpty)
    }

    func testStreamsNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.videoStreamed]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = Videos.streams
        XCTAssertFalse(videos.isEmpty)
    }

    func testHighFrameRatesEmpty() {
        let videos = Videos.highFrameRates
        XCTAssertTrue(videos.isEmpty)
    }

    func testHighFrameRatesNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.videoHighFrameRate]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = Videos.highFrameRates
        XCTAssertFalse(videos.isEmpty)
    }

    func testTimelapsesEmpty() {
        let videos = Videos.timelapses
        XCTAssertTrue(videos.isEmpty)
    }

    func testTimelapsesNotEmpty() {
        mockAsset.mediaSubtypesToReturn = [.videoTimelapse]
        MockPHAsset.fetchResult.mockAssets = [mockAsset]
        let videos = Videos.timelapses
        XCTAssertFalse(videos.isEmpty)
    }
}
