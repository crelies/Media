//
//  AudioTests.swift
//  MediaTests
//
//  Created by Christian Elies on 18.12.19.
//

@testable import MediaCore
import XCTest

final class AudioTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    func testWithIdentifierExists() {
        do {
            let localIdentifier = "Lopa"

            let mockAudio = MockPHAsset()
            mockAudio.mediaTypeToReturn = .audio
            mockAudio.localIdentifierToReturn = localIdentifier
            MockPHAsset.fetchResult.mockAssets = [mockAudio]

            let identifier = Media.Identifier<Audio>(stringLiteral: localIdentifier)
            let audio = try Audio.with(identifier: identifier)
            XCTAssertNotNil(audio)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testWithIdentifierNotExists() {
        do {
            let localIdentifier = "Lopa"
            let identifier = Media.Identifier<Audio>(stringLiteral: localIdentifier)
            let audio = try Audio.with(identifier: identifier)
            XCTAssertNil(audio)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
