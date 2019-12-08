//
//  VideoExportQualityTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

import AVFoundation
@testable import Media
import XCTest

final class VideoExportQualityTests: XCTestCase {
    func testLowAVAssetExportPreset() {
        let quality: Video.ExportQuality = .low
        let expectedExportPreset = AVAssetExportPresetLowQuality
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testMediumAVAssetExportPreset() {
        let quality: Video.ExportQuality = .medium
        let expectedExportPreset = AVAssetExportPresetMediumQuality
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testHighestAVAssetExportPreset() {
        let quality: Video.ExportQuality = .highest
        let expectedExportPreset = AVAssetExportPresetHighestQuality
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testq640x480AVAssetExportPreset() {
        let quality: Video.ExportQuality = .q640x480
        let expectedExportPreset = AVAssetExportPreset640x480
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testq960x540AVAssetExportPreset() {
        let quality: Video.ExportQuality = .q960x540
        let expectedExportPreset = AVAssetExportPreset960x540
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testq1280x720AVAssetExportPreset() {
        let quality: Video.ExportQuality = .q1280x720
        let expectedExportPreset = AVAssetExportPreset1280x720
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testq1920x1080AVAssetExportPreset() {
        let quality: Video.ExportQuality = .q1920x1080
        let expectedExportPreset = AVAssetExportPreset1920x1080
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }

    func testq3840x2160AVAssetExportPreset() {
        let quality: Video.ExportQuality = .q3840x2160
        let expectedExportPreset = AVAssetExportPreset3840x2160
        XCTAssertEqual(quality.avAssetExportPreset, expectedExportPreset)
    }
}
