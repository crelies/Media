//
//  PhotoFileTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

import AVFoundation
@testable import Media
import XCTest

final class PhotoFileTypeTests: XCTestCase {
    func testAVCIPathExtensions() {
        let fileType: Photo.FileType = .avci
        let expectedPathExtensions: [String] = ["avci"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtensions)
    }

    @available(iOS 11, *)
    func testAVCIAVFileType() {
        let fileType: Photo.FileType = .avci
        let expectedAVFileType: AVFileType = .avci
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testHEICPathExtensions() {
        let fileType: Photo.FileType = .heic
        let expectedPathExtensions: [String] = ["heic"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtensions)
    }

    @available(iOS 11, *)
    func testHEICAVFileType() {
        let fileType: Photo.FileType = .heic
        let expectedAVFileType: AVFileType = .heic
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testHEIFPathExtensions() {
        let fileType: Photo.FileType = .heif
        let expectedPathExtensions: [String] = ["heif"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtensions)
    }

    @available(iOS 11, *)
    func testHEIFAVFileType() {
        let fileType: Photo.FileType = .heif
        let expectedAVFileType: AVFileType = .heif
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testJPGPathExtensions() {
        let fileType: Photo.FileType = .jpg
        let expectedPathExtensions: [String] = ["jpg", "jpeg"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtensions)
    }

    @available(iOS 11, *)
    func testJPGAVFileType() {
        let fileType: Photo.FileType = .jpg
        let expectedAVFileType: AVFileType = .jpg
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }

    func testTIFPathExtensions() {
        let fileType: Photo.FileType = .tif
        let expectedPathExtensions: [String] = ["tiff", "tif"]
        XCTAssertEqual(fileType.pathExtensions, expectedPathExtensions)
    }

    @available(iOS 11, *)
    func testTIFAVFileType() {
        let fileType: Photo.FileType = .tif
        let expectedAVFileType: AVFileType = .tif
        XCTAssertEqual(fileType.avFileType, expectedAVFileType)
    }
}
