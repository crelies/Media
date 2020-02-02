//
//  FileManagerTests.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

@testable import Media
import XCTest

final class FileManagerTests: XCTestCase {
    func testCachesDirectory() {
        let fileManager: FileManager = .default
        XCTAssertEqual(fileManager.cachesDirectory, fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first)
    }
}
