//
//  LivePhotoFileTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import MediaCore
import XCTest

final class LivePhotoFileTypeTests: XCTestCase {
    func testMovPathExtensions() {
        let fileType: LivePhoto.FileType = .mov
        XCTAssertFalse(fileType.pathExtensions.isEmpty)
    }
}
