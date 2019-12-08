//
//  MediaIdentifierTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class MediaIdentifierTests: XCTestCase {
    func testExpressibleByStringLiteral() {
        let identifier = "Test"
        let mediaIdentifier = Media.Identifier<Video>(stringLiteral: identifier)
        XCTAssertEqual(mediaIdentifier.localIdentifier, identifier)
    }

    func testDescription() {
        let identifier = "Test"
        let mediaIdentifier = Media.Identifier<Video>(stringLiteral: identifier)
        XCTAssertEqual(mediaIdentifier.description, identifier)
    }
}
