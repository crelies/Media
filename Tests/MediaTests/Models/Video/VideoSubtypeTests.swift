//
//  VideoSubtypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class VideoSubtypeTests: XCTestCase {
    func testStreamedMediaSubtype() {
        let subtype: VideoSubtype = .streamed
        let expectedMediaSubtype: MediaSubtype = .videoStreamed
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }

    func testHighFrameRateMediaSubtype() {
        let subtype: VideoSubtype = .highFrameRate
        let expectedMediaSubtype: MediaSubtype = .videoHighFrameRate
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }

    func testTimelapseMediaSubtype() {
        let subtype: VideoSubtype = .timelapse
        let expectedMediaSubtype: MediaSubtype = .videoTimelapse
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }

    static var allTests = [
        ("testStreamedMediaSubtype", testStreamedMediaSubtype),
        ("testHighFrameRateMediaSubtype", testHighFrameRateMediaSubtype),
        ("testTimelapseMediaSubtype", testTimelapseMediaSubtype)
    ]
}
