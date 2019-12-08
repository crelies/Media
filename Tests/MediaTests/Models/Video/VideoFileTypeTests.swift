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
    func testMovPathExtensions() {
        let fileType: Video.FileType = .mov
        let expectedPathExtension = ["mov"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtension)
    }

    func testMovAVFileType() {
        let fileType: Video.FileType = .mov
        let expectedAVFileType: AVFileType = .mov
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testMP4PathExtensions() {
        let fileType: Video.FileType = .mp4
        let expectedPathExtension = ["mp4"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtension)
    }

    func testMP4AVFileType() {
        let fileType: Video.FileType = .mp4
        let expectedAVFileType: AVFileType = .mp4
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testM4VPathExtensions() {
        let fileType: Video.FileType = .m4v
        let expectedPathExtension = ["m4v"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtension)
    }

    func testM4VAVFileType() {
        let fileType: Video.FileType = .m4v
        let expectedAVFileType: AVFileType = .m4v
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }
}
