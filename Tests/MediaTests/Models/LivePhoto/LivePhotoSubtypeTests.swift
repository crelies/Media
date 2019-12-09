//
//  LivePhotoSubtypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import Media
import XCTest

final class LivePhotoSubtypeTests: XCTestCase {
    func testLiveMediaSubtype() {
        let subtype: LivePhotoSubtype = .live
        XCTAssertEqual(subtype.mediaSubtype, .photoLive)
    }
}
