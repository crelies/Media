//
//  OptionalString+compareTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class OptionalString_compareTests: XCTestCase {
    func testTwoNone() {
        let first: String? = nil
        let second: String? = nil
        XCTAssertEqual(first.compare(second), .orderedSame)
    }

    func testTwoSomeEqual() {
        let first: String? = "a"
        let second: String? = "a"
        XCTAssertEqual(first.compare(second), .orderedSame)
    }

    func testTwoSomeNotEqual() {
        let first: String? = "a"
        let second: String? = "b"
        XCTAssertEqual(first.compare(second), .orderedAscending)
    }

    func testFirstSome() {
        let first: String? = "a"
        let second: String? = nil
        XCTAssertEqual(first.compare(second), .orderedDescending)
    }

    func testSecondSome() {
        let first: String? = nil
        let second: String? = "a"
        XCTAssertEqual(first.compare(second), .orderedAscending)
    }
}
