//
//  AlbumFetcherTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import Media
import Photos
import XCTest

@available(macOS 10.15, *)
final class AlbumFetcherTests: XCTestCase {
    override func setUp() {
        AlbumFetcher.assetCollection = MockPHAssetCollection.self
        MockPHAssetCollection.fetchResult.mockAssetCollections.removeAll()
    }

    func testFetchAlbumsWithNoAlbums() {
        let options = PHFetchOptions()
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)
        XCTAssertEqual(albums.count, 0)
    }

    func testFetchAlbumsWithAlbums() {
        let options = PHFetchOptions()
        MockPHAssetCollection.fetchResult.mockAssetCollections = [MockPHAssetCollection()]
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)
        XCTAssertEqual(albums.count, 1)
    }

    func testFetchAlbumsWithFilter() {
        let assetCollection = MockPHAssetCollection()
        assetCollection.assetCollectionSubtypeToReturn = .albumRegular
        MockPHAssetCollection.fetchResult.mockAssetCollections = [assetCollection]
        let options = PHFetchOptions()
        let albums = AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { $0.assetCollectionSubtype == .albumRegular }
        XCTAssertFalse(albums.isEmpty)
    }

    func testFetchAlbumWithNoAlbum() {
        let options = PHFetchOptions()
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options)
        XCTAssertNil(album)
    }

    func testFetchAlbumWithAlbum() {
        let options = PHFetchOptions()
        MockPHAssetCollection.fetchResult.mockAssetCollections = [MockPHAssetCollection()]
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options)
        XCTAssertNotNil(album)
    }

    func testFetchAlbumWithFilter() {
        let assetCollection = MockPHAssetCollection()
        assetCollection.assetCollectionSubtypeToReturn = .albumRegular
        MockPHAssetCollection.fetchResult.mockAssetCollections = [assetCollection]
        let options = PHFetchOptions()
        let album = AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { $0.assetCollectionSubtype == .albumRegular }
        XCTAssertNotNil(album)
    }
}
