//
//  AudioSubtypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import MediaCore
import XCTest

final class AudioSubtypeTests: XCTestCase {
    func testMediaSubtype() {
        let audioSubtype: Audio.Subtype? = .none
        XCTAssertNil(audioSubtype?.mediaSubtype)
    }
}
