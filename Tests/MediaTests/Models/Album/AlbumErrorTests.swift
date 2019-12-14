//
//  AlbumErrorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import XCTest

final class AlbumErrorTests: XCTestCase {
    func testAlbumWithTitleExistsDescription() {
        let title = "TestAlbum"
        let description = AlbumError.albumWithTitleExists(title).localizedDescription
        let expectedDescription = "An album with the title \(title) already exists."
        XCTAssertEqual(description, expectedDescription)
    }
}
