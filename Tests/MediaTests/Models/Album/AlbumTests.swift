//
//  AlbumTests.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

@testable import MediaCore
import XCTest

final class AlbumTests: XCTestCase {
    let mockAssetCollection = MockPHAssetCollection()
    lazy var album = Album(phAssetCollection: mockAssetCollection)

    override func setUp() {
        FetchAllAssets.phAsset = MockPHAsset.self
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
        mockAssetCollection.assetCollectionTypeToReturn = .moment
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

    func testAllMediaNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        let items = album.allMedia
        XCTAssertFalse(items.isEmpty)
    }

    func testAllMediaEmpty() {
        let items = album.allMedia
        XCTAssertTrue(items.isEmpty)
    }

    func testAlbumWithIdentifierExists() {
        do {
            let localIdentifier = "Nebula"
            mockAssetCollection.localIdentifierToReturn = localIdentifier
            MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
            let album = try Album.with(identifier: .init(stringLiteral: localIdentifier))
            XCTAssertNotNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAlbumWithIdentifierNil() {
        do {
            let album = try Album.with(identifier: .init(stringLiteral: "Xikola"))
            XCTAssertNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAlbumWithLocalizedTitleExists() {
        do {
            let localizedTitle = "Lopasr"
            mockAssetCollection.localizedTitleToReturn = localizedTitle
            MockPHAssetCollection.fetchResult.mockAssetCollections = [mockAssetCollection]
            let album = try Album.with(localizedTitle: localizedTitle)
            XCTAssertNotNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testAlbumWithLocalizedTitleNil() {
        do {
            let album = try Album.with(localizedTitle: "Bluabo")
            XCTAssertNil(album)
        } catch {
            XCTFail(error.localizedDescription)
        }
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
            guard case let Album.Error.albumWithTitleExists(title) = error else {
                XCTFail("Invalid error")
                return
            }
            XCTAssertEqual(title, localizedTitle)
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
            XCTFail("Invalid album create result \(String(describing: result))")
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
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        let expectation = self.expectation(description: "AlbumDeleteResult")

        var result: Result<Void, Error>?
        album.delete { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid album delete result \(String(describing: result))")
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
            XCTFail("Invalid album delete result \(String(describing: result))")
        }
    }

    func testAlbumMetadata() {
        mockAssetCollection.assetCollectionTypeToReturn = .album

        let metadata = album.metadata
        XCTAssertEqual(metadata?.assetCollectionType, .album)
    }

    func testAddMediaSuccess() {
        let expectation = self.expectation(description: "AddMediaResult")

        let asset = MockPHAsset()
        let photo = Photo(phAsset: asset)

        var result: Result<Void, Error>?
        album.add(photo) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Unexpected result: \(String(describing: result))")
        }
    }

    func testAddMediaFailure() {
        let expectation = self.expectation(description: "AddMediaResult")

        let asset = MockPHAsset()
        let photo = Photo(phAsset: asset)
        photo.phAssetWrapper.value = nil

        var result: Result<Void, Error>?
        album.add(photo) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .noUnderlyingPHAssetFound)
        default:
            XCTFail("Unexpected result: \(String(describing: result))")
        }
    }

    func testDeleteMediaSuccess() {
        let expectation = self.expectation(description: "DeleteMediaResult")

        let asset = MockPHAsset()
        let photo = Photo(phAsset: asset)

        var result: Result<Void, Error>?
        album.delete(photo) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Unexpected result: \(String(describing: result))")
        }
    }

    func testDeleteMediaFailure() {
        let expectation = self.expectation(description: "DeleteMediaResult")

        let asset = MockPHAsset()
        let photo = Photo(phAsset: asset)
        photo.phAssetWrapper.value = nil

        var result: Result<Void, Error>?
        album.delete(photo) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .noUnderlyingPHAssetFound)
        default:
            XCTFail("Unexpected result: \(String(describing: result))")
        }
    }
}
