//
//  AnyMediaIdentifierTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import XCTest

final class AnyMediaIdentifierTests: XCTestCase {
    func testInitialization() {
        let localIdentifier = "MockLocalIdentifier"
        let mediaIdentifier = Media.Identifier<Photo>(stringLiteral: localIdentifier)
        let anyMediaIdentifier = AnyMediaIdentifier(mediaIdentifier)
        XCTAssertEqual(anyMediaIdentifier.localIdentifier, localIdentifier)
    }
}
