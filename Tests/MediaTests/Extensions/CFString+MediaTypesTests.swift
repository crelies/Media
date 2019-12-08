//
//  CFString+MediaTypesTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import MobileCoreServices
import XCTest

final class CFStringTests: XCTestCase {
    func testImage() {
        XCTAssertEqual(CFString.image, kUTTypeImage)
    }

    func testLivePhoto() {
        XCTAssertEqual(CFString.livePhoto, kUTTypeLivePhoto)
    }

    func testMovie() {
        XCTAssertEqual(CFString.movie, kUTTypeMovie)
    }
}
