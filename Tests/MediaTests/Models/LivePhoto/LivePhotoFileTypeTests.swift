//
//  LivePhotoFileTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import Media
import XCTest

final class LivePhotoFileTypeTests: XCTestCase {
    func testNonePathExtensions() {
        let fileType: LivePhoto.FileType = .none
        XCTAssertTrue(fileType.pathExtensions.isEmpty)
    }
}
