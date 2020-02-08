//
//  AlbumsTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.12.19.
//

@testable import MediaCore
import XCTest

final class AlbumsTests: XCTestCase {
    let mockAssetCollection = MockPHAssetCollection()

    override func setUp() {
        AlbumFetcher.assetCollection = MockPHAssetCollection.self
        MockPHAssetCollection.fetchResult.mockAssetCollections.removeAll()
        mockAssetCollection.assetCollectionTypeToReturn = .album
        mockAssetCollection.assetCollectionSubtypeToReturn = .albumRegular
    }

    func testAllEmpty() {
        let albums = Albums.all
        XCTAssertTrue(albums.isEmpty)
    }

    func testAllNotEmpty() {
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
        let albums = Albums.all
        XCTAssertFalse(albums.isEmpty)
    }

    func testUserEmpty() {
        let albums = Albums.user
        XCTAssertTrue(albums.isEmpty)
    }

    func testUserNotEmpty() {
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
        let albums = Albums.user
        XCTAssertFalse(albums.isEmpty)
    }

    func testSmartEmpty() {
        mockAssetCollection.assetCollectionTypeToReturn = .smartAlbum
        mockAssetCollection.assetCollectionSubtypeToReturn = .smartAlbumScreenshots
        let albums = Albums.smart
        XCTAssertTrue(albums.isEmpty)
    }

    func testSmartNotEmpty() {
        mockAssetCollection.assetCollectionTypeToReturn = .smartAlbum
        mockAssetCollection.assetCollectionSubtypeToReturn = .smartAlbumScreenshots
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
        let albums = Albums.smart
        XCTAssertFalse(albums.isEmpty)
    }

    func testCloudEmpty() {
        let albums = Albums.cloud
        XCTAssertTrue(albums.isEmpty)
    }

    func testCloudNotEmpty() {
        mockAssetCollection.assetCollectionSubtypeToReturn = .albumMyPhotoStream
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
        let albums = Albums.cloud
        XCTAssertFalse(albums.isEmpty)
    }
}
