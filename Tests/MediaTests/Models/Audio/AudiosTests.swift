//
//  AudiosTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import Media
import XCTest

final class AudiosTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    @available(macOS 10.15, *)
    func testAllEmpty() {
        let audios = Audios.all
        XCTAssertTrue(audios.isEmpty)
    }

    @available(macOS 10.15, *)
    func testAllNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let audios = Audios.all
        XCTAssertEqual(audios.count, 1)
    }
}
