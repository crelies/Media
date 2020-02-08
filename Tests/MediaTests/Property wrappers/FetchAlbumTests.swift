//
//  FetchAlbumTests.swift
//  MediaTests
//
//  Created by Christian Elies on 17.12.19.
//

@testable import MediaCore
import XCTest

final class FetchAlbumTests: XCTestCase {
    override func setUp() {
        AlbumFetcher.assetCollection = MockPHAssetCollection.self
        MockPHAssetCollection.fetchResult.mockAssetCollections.removeAll()
    }

    func testAlbum() {
        let localIdentifier = "Hurli"
        MockPropertyWrapperExample.localIdentifierToUse = localIdentifier
        
        var testAlbum = MockPropertyWrapperExample.testAlbum
        XCTAssertNil(testAlbum)

        let mockAlbum = MockPHAssetCollection()
        mockAlbum.localIdentifierToReturn = localIdentifier
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAlbum]

        testAlbum = MockPropertyWrapperExample.testAlbum
        XCTAssertNotNil(testAlbum)
    }
}
