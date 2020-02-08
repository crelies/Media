//
//  AudiosTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import MediaCore
import XCTest

final class AudiosTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    func testAllEmpty() {
        let audios = Audios.all
        XCTAssertTrue(audios.isEmpty)
    }

    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let audios = Audios.all
        XCTAssertEqual(audios.count, 1)
    }
}
