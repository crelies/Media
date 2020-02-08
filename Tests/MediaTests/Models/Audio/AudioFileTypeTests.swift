//
//  AudioFileTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import MediaCore
import XCTest

final class AudioFileTypeTests: XCTestCase {
    func testNonePathExtensions() {
        let fileType: Audio.FileType = .none
        XCTAssertTrue(fileType.pathExtensions.isEmpty)
    }
}
