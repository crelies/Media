@testable import MediaCore
import XCTest

final class LazyAlbumTests: XCTestCase {
    let mockAssetCollection = MockPHAssetCollection()
    lazy var album = LazyAlbum(albumType: nil, assetCollectionProvider: self.mockAssetCollection)

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

    func testLocalizedTitle() {
        XCTAssertEqual(album.localizedTitle, mockAssetCollection.localizedTitle)
    }

    func testPhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        XCTAssertNotNil(album.photos)
        XCTAssertEqual(album.photos?.count ?? 0, 1)
    }

    func testPhotosEmpty() {
        XCTAssertNotNil(album.photos)
        XCTAssertEqual(album.photos?.count ?? 0, 0)
    }

    func testLivePhotosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        XCTAssertNotNil(album.livePhotos)
        XCTAssertEqual(album.livePhotos?.count ?? 0, 1)
    }

    func testLivePhotosEmpty() {
        XCTAssertNotNil(album.livePhotos)
        XCTAssertEqual(album.livePhotos?.count ?? 0, 0)
    }

    func testVideosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        XCTAssertNotNil(album.videos)
        XCTAssertEqual(album.videos?.count ?? 0, 1)
    }

    func testVideosEmpty() {
        XCTAssertNotNil(album.videos)
        XCTAssertEqual(album.videos?.count ?? 0, 0)
    }

    func testAudiosNotEmpty() {
        MockPHAsset.fetchResult.mockAssets = [MockPHAsset()]
        XCTAssertNotNil(album.audios)
        XCTAssertEqual(album.audios?.count ?? 0, 1)
    }

    func testAudiosEmpty() {
        XCTAssertNotNil(album.audios)
        XCTAssertEqual(album.audios?.count ?? 0, 0)
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
}
