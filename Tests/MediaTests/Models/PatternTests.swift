//
//  PatternTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import MediaCore
import XCTest

final class PatternTests: XCTestCase {
    func testMismatchs() {
        let value = "huhu"
        switch value {
        case .mismatchs("hallo"): ()
        default:
            XCTFail("Unexpected case")
        }
    }
}
