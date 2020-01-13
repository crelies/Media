//
//  PhotoSubtypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class PhotoSubtypeTests: XCTestCase {
    func testPanoramaMediaSubtype() {
        let subtype: PhotoSubtype = .panorama
        let expectedMediaSubtype: MediaSubtype = .photoPanorama
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }

    func testHDRMediaSubtype() {
        let subtype: PhotoSubtype = .hdr
        let expectedMediaSubtype: MediaSubtype = .photoHDR
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }

    func testScreenshotMediaSubtype() {
        let subtype: PhotoSubtype = .screenshot
        let expectedMediaSubtype: MediaSubtype = .photoScreenshot
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }

    @available(iOS 10.2, *)
    @available(tvOS 10.1, *)
    func testDepthEffectMediaSubtype() {
        let subtype: PhotoSubtype = .depthEffect
        let expectedMediaSubtype: MediaSubtype = .photoDepthEffect
        XCTAssertEqual(subtype.mediaSubtype, expectedMediaSubtype)
    }
}
