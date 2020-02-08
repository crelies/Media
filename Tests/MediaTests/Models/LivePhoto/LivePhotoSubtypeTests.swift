//
//  LivePhotoSubtypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import MediaCore
import XCTest

final class LivePhotoSubtypeTests: XCTestCase {
    func testLiveMediaSubtype() {
        let subtype: LivePhoto.Subtype = .live
        XCTAssertEqual(subtype.mediaSubtype, .photoLive)
    }
}
