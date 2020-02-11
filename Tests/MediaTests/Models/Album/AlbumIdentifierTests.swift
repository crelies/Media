//
//  AlbumIdentifierTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import MediaCore
import XCTest

final class AlbumIdentifierTests: XCTestCase {
    func testExpressibleByStringLiteral() {
        let identifier = "Test"
        let albumIdentifier = Album.Identifier(stringLiteral: identifier)
        XCTAssertEqual(albumIdentifier.localIdentifier, identifier)
    }

    func testDescription() {
        let identifier = "Test"
        let albumIdentifier = Album.Identifier(stringLiteral: identifier)
        XCTAssertEqual(albumIdentifier.localIdentifier, identifier)
    }
}
