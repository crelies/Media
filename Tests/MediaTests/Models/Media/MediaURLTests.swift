//
//  MediaURLTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class MediaURLTests: XCTestCase {
    func testNoPathExtension() {
        do {
            let url = URL(fileURLWithPath: "file:///test")
            _ = try MediaURL<Photo>(url: url)
        } catch {
            let error = error as? MediaURLError
            XCTAssertEqual(error, .missingPathExtension)
        }
    }

    func testUnsupportedPhotoFileType() {
        do {
            let url = URL(fileURLWithPath: "file:///test.\(Video.FileType.mov.pathExtensions.first!)")
            _ = try MediaURL<Photo>(url: url)
        } catch {
            let error = error as? MediaURLError
            XCTAssertEqual(error, .unsupportedPathExtension)
        }
    }

    func testSupportedPhotoFileType() {
        do {
            let url = URL(fileURLWithPath: "file:///test.\(Photo.FileType.jpg.pathExtensions.first!)")
            _ = try MediaURL<Photo>(url: url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testUnsupportedVideoFileType() {
        do {
            let url = URL(fileURLWithPath: "file:///test.\(Photo.FileType.jpg.pathExtensions.first!)")
            _ = try MediaURL<Video>(url: url)
        } catch {
            let error = error as? MediaURLError
            XCTAssertEqual(error, .unsupportedPathExtension)
        }
    }

    func testSupportedVideoFileType() {
        do {
            let url = URL(fileURLWithPath: "file:///test.\(Video.FileType.mov.pathExtensions.first!)")
            _ = try MediaURL<Video>(url: url)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
