//
//  AlbumFetcherTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import MediaCore
import Photos
import XCTest

final class AlbumFetcherTests: XCTestCase {
    override func setUp() {
        Media.photoLibrary = MockPhotoLibrary.self
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        AlbumFetcher.assetCollection = MockPHAssetCollection.self
        MockPHAssetCollection.fetchResult.mockAssetCollections.removeAll()
    }

    func testFetchAlbumsWithNoAlbums() {
        do {
            let options = PHFetchOptions()
            let albums = try AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)
            XCTAssertEqual(albums.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchAlbumsWithAlbums() {
        do {
            let options = PHFetchOptions()
            MockPHAssetCollection.fetchResult.mockAssetCollections = [MockPHAssetCollection()]
            let albums = try AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options)
            XCTAssertEqual(albums.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchAlbumsWithFilter() {
        do {
            let assetCollection = MockPHAssetCollection()
            assetCollection.assetCollectionSubtypeToReturn = .albumRegular
            MockPHAssetCollection.fetchResult.mockAssetCollections = [assetCollection]
            let options = PHFetchOptions()
            let albums = try AlbumFetcher.fetchAlbums(with: .album, subtype: .any, options: options) { $0.assetCollectionSubtype == .albumRegular }
            XCTAssertFalse(albums.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchAlbumWithNoAlbum() {
        do {
            let options = PHFetchOptions()
            let album = try AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options)
            XCTAssertNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchAlbumWithAlbum() {
        do {
            let options = PHFetchOptions()
            MockPHAssetCollection.fetchResult.mockAssetCollections = [MockPHAssetCollection()]
            let album = try AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options)
            XCTAssertNotNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFetchAlbumWithFilter() {
        do {
            let assetCollection = MockPHAssetCollection()
            assetCollection.assetCollectionSubtypeToReturn = .albumRegular
            MockPHAssetCollection.fetchResult.mockAssetCollections = [assetCollection]
            let options = PHFetchOptions()
            let album = try AlbumFetcher.fetchAlbum(with: .album, subtype: .any, options: options) { $0.assetCollectionSubtype == .albumRegular }
            XCTAssertNotNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
