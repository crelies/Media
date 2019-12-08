//
//  VideoFileTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

import AVFoundation
@testable import Media
import XCTest

final class VideoFileTypeTests: XCTestCase {
    func testMovPathExtension() {
        let fileType: Video.FileType = .mov
        let expectedPathExtension = "mov"
        XCTAssertEqual(fileType.pathExtension, expectedPathExtension)
    }

    func testMovAVFileType() {
        let fileType: Video.FileType = .mov
        let expectedAVFileType: AVFileType = .mov
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testMP4PathExtension() {
        let fileType: Video.FileType = .mp4
        let expectedPathExtension = "mp4"
        XCTAssertEqual(fileType.pathExtension, expectedPathExtension)
    }

    func testMP4AVFileType() {
        let fileType: Video.FileType = .mp4
        let expectedAVFileType: AVFileType = .mp4
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testM4VPathExtension() {
        let fileType: Video.FileType = .m4v
        let expectedPathExtension = "m4v"
        XCTAssertEqual(fileType.pathExtension, expectedPathExtension)
    }

    func testM4VAVFileType() {
        let fileType: Video.FileType = .m4v
        let expectedAVFileType: AVFileType = .m4v
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }
}
