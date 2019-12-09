//
//  AudioSubtypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import Media
import XCTest

final class AudioSubtypeTests: XCTestCase {
    func testMediaSubtype() {
        let audioSubtype: AudioSubtype? = .none
        XCTAssertNil(audioSubtype?.mediaSubtype)
    }
}
