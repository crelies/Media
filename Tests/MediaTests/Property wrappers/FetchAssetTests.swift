//
//  FetchAssetTests.swift
//  MediaTests
//
//  Created by Christian Elies on 17.12.19.
//

@testable import MediaCore
import XCTest

final class FetchAssetTests: XCTestCase {
    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    func testAsset() {
        let localIdentifier = "Arolp"
        MockPropertyWrapperExample.localIdentifierToUse = localIdentifier
        
        var testAsset = MockPropertyWrapperExample.testPhoto
        XCTAssertNil(testAsset)

        let mockAsset = MockPHAsset()
        mockAsset.localIdentifierToReturn = localIdentifier
        mockAsset.mediaTypeToReturn = .image
        MockPHAsset.fetchResult.mockAssets = [mockAsset]

        testAsset = MockPropertyWrapperExample.testPhoto
        XCTAssertNotNil(testAsset)
    }
}
