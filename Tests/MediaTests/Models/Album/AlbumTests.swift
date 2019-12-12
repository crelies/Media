//
//  AlbumTests.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

@testable import Media
import XCTest

final class AlbumTests: XCTestCase {
    let mockAssetCollection = MockPHAssetCollection()
    lazy var album = Album(phAssetCollection: mockAssetCollection)

    override func setUp() {
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        AlbumFetcher.assetCollection = MockPHAssetCollection.self
        MockPHAssetCollection.fetchResult.mockAssetCollections.removeAll()
        mockAssetCollection.localIdentifierToReturn = ""
        mockAssetCollection.localizedTitleToReturn = ""
        Media.photoLibrary = MockPhotoLibrary.self
        PHChanger.photoLibrary = MockPhotoLibrary()
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
    }

    func testAudiosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.audios
        XCTAssertFalse(items.isEmpty)
    }

    func testAudiosEmpty() {
        let items = album.audios
        XCTAssertTrue(items.isEmpty)
    }

    func testPhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.photos
        XCTAssertFalse(items.isEmpty)
    }

    func testPhotosEmpty() {
        let items = album.photos
        XCTAssertTrue(items.isEmpty)
    }

    func testVideosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.videos
        XCTAssertFalse(items.isEmpty)
    }

    func testVideosEmpty() {
        let items = album.videos
        XCTAssertTrue(items.isEmpty)
    }

    func testLivePhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.livePhotos
        XCTAssertFalse(items.isEmpty)
    }

    func testLivePhotosEmpty() {
        let items = album.livePhotos
        XCTAssertTrue(items.isEmpty)
    }

    // TODO:
    /*func testAllMediaNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.allMedia
        XCTAssertFalse(items.isEmpty)
    }*/

    func testAllMediaEmpty() {
        let items = album.allMedia
        XCTAssertTrue(items.isEmpty)
    }

    func testAlbumWithIdentifierExists() {
        let localIdentifier = "Nebula"
        mockAssetCollection.localIdentifierToReturn = localIdentifier
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
        let album = Album.with(identifier: .init(stringLiteral: localIdentifier))
        XCTAssertNotNil(album)
    }

    func testAlbumWithIdentifierNil() {
        let album = Album.with(identifier: .init(stringLiteral: "Xikola"))
        XCTAssertNil(album)
    }

    func testAlbumWithLocalizedTitleExists() {
        let localizedTitle = "Lopasr"
        mockAssetCollection.localizedTitleToReturn = localizedTitle
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
        let album = Album.with(localizedTitle: localizedTitle)
        XCTAssertNotNil(album)
    }

    func testAlbumWithLocalizedTitleNil() {
        let album = Album.with(localizedTitle: "Bluabo")
        XCTAssertNil(album)
    }

    func testAlbumCreatePermissionDenied() {
        MockPhotoLibrary.authorizationStatusToReturn = .denied

        let expectation = self.expectation(description: "AlbumCreateResult")

        var result: Result<Void, Error>?
        Album.create(title: "Test") { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? PermissionError, .denied)
        default:
            XCTFail("Invalid album create result")
        }
    }

    func testAlbumCreateExists() {
        let localizedTitle = "ExistingTitle"
        mockAssetCollection.localizedTitleToReturn = localizedTitle
        MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]

        let expectation = self.expectation(description: "AlbumCreateResult")

        var result: Result<Void, Error>?
        Album.create(title: localizedTitle) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? AlbumError, .albumWithTitleExists)
        default:
            XCTFail("Invalid album create result")
        }
    }

    func testAlbumCreateNotExists() {
        let expectation = self.expectation(description: "AlbumCreateResult")

        var result: Result<Void, Error>?
        Album.create(title: "Jupol") { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid album create result")
        }
    }

    func testAlbumDeletePermissionDenied() {
        MockPhotoLibrary.authorizationStatusToReturn = .denied

        let expectation = self.expectation(description: "AlbumDeleteResult")

        var result: Result<Void, Error>?
        album.delete { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? PermissionError, .denied)
        default:
            XCTFail("Invalid album delete result")
        }
    }

    func testAlbumDeleteFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        let expectation = self.expectation(description: "AlbumDeleteResult")

        var result: Result<Void, Error>?
        album.delete { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid album delete result")
        }
    }

    func testAlbumDeleteSuccess() {
        let expectation = self.expectation(description: "AlbumDeleteResult")

        var result: Result<Void, Error>?
        album.delete { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid album delete result")
        }
    }
}
