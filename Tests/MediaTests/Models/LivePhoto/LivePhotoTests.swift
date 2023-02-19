//
//  LivePhotoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 15.12.19.
//

@testable import MediaCore
import Photos
import XCTest

final class LivePhotoTests: XCTestCase {
    let asset = MockPHAsset()
    let livePhotoManager = MockLivePhotoManager()
    let photoLibrary = MockPhotoLibrary()
    lazy var livePhoto = LivePhoto(phAsset: asset)

    override func setUp() {
        LivePhoto.livePhotoManager = livePhotoManager
        PHAssetFetcher.asset = MockPHAsset.self

        PHAssetChanger.photoLibrary = photoLibrary
        PHAssetChanger.photoLibraryChangeObserver = MockPhotoLibraryChangeObserver.self

        livePhotoManager.livePhotoToReturn = nil
        livePhotoManager.infoToReturn = nil

        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil

        asset.localIdentifierToReturn = ""
        asset.mediaTypeToReturn = .audio
        asset.mediaSubtypesToReturn = .videoHighFrameRate

        MockPHAsset.fetchResult.mockAssets.removeAll()

        livePhoto.phAssetWrapper.value = asset
    }

    #if !os(macOS) && !targetEnvironment(macCatalyst)
    @available(iOS 10, *)
    func testDisplayRepresentationHighQualitySuccess() {
        livePhotoManager.livePhotoToReturn = MockPHLivePhoto()
        livePhotoManager.infoToReturn = [PHImageResultIsDegradedKey: NSNumber(booleanLiteral: false)]

        let expectation = self.expectation(description: "DisplayRepresentationResult")

        var result: Result<Media.DisplayRepresentation<PHLivePhotoProtocol>, Error>?
        let targetSize = CGSize(width: 20, height: 20)
        livePhoto.displayRepresentation(targetSize: targetSize) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success(let representation):
            XCTAssertEqual(representation.quality, .high)
        default:
            XCTFail("Invalid display representaiton result \(String(describing: result))")
        }
    }

    @available(iOS 10, *)
    func testDisplayRepresentationLowQualitySuccess() {
        livePhotoManager.livePhotoToReturn = MockPHLivePhoto()
        livePhotoManager.infoToReturn = [PHImageResultIsDegradedKey: NSNumber(booleanLiteral: true)]

        let expectation = self.expectation(description: "DisplayRepresentationResult")

        var result: Result<Media.DisplayRepresentation<PHLivePhotoProtocol>, Error>?
        let targetSize = CGSize(width: 20, height: 20)
        livePhoto.displayRepresentation(targetSize: targetSize) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success(let representation):
            XCTAssertEqual(representation.quality, .low)
        default:
            XCTFail("Invalid display representaiton result \(String(describing: result))")
        }
    }

    func testDisplayRepresentationFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        let expectation = self.expectation(description: "DisplayRepresentationResult")

        var result: Result<Media.DisplayRepresentation<PHLivePhotoProtocol>, Error>?
        let targetSize = CGSize(width: 20, height: 20)
        livePhoto.displayRepresentation(targetSize: targetSize) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid display representaiton result \(String(describing: result))")
        }
    }
    #endif

    func testWithIdentifierExists() {
        do {
            let localIdentifier = "Lopar"
            asset.localIdentifierToReturn = localIdentifier
            asset.mediaTypeToReturn = .image
            asset.mediaSubtypesToReturn = .photoLive
            MockPHAsset.fetchResult.mockAssets = [asset]

            let identifier = Media.Identifier<LivePhoto>(stringLiteral: localIdentifier)
            let livePhoto = try LivePhoto.with(identifier: identifier)
            XCTAssertNotNil(livePhoto)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testWithIdentifierNotExists() {
        do {
            let localIdentifier = "Blop"
            let identifier = Media.Identifier<LivePhoto>(stringLiteral: localIdentifier)
            let livePhoto = try LivePhoto.with(identifier: identifier)
            XCTAssertNil(livePhoto)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFavoriteSuccess() {
        let expectation = self.expectation(description: "FavoriteResult")

        var result: Result<Void, Error>?
        let isFavorite = false
        livePhoto.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid favorite result \(String(describing: result))")
        }
    }

    func testFavoriteFailure() {
        let expectation = self.expectation(description: "FavoriteResult")

        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        var result: Result<Void, Error>?
        let isFavorite = false
        livePhoto.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid favorite result \(String(describing: result))")
        }
    }

    func testFavoriteMissingPHAsset() {
        livePhoto.phAssetWrapper.value = nil

        let expectation = self.expectation(description: "FavoriteResult")

        var result: Result<Void, Error>?
        let isFavorite = false
        livePhoto.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, .noUnderlyingPHAssetFound)
        default:
            XCTFail("Invalid favorite result \(String(describing: result))")
        }
    }

    func testMetadata() {
        let metadata = livePhoto.metadata
        XCTAssertNotNil(metadata)
    }

    #if !targetEnvironment(macCatalyst)
    @available(iOS 10, *)
    @available(tvOS, unavailable)
    func testSaveFailure() {
        do {
            MockPhotoLibrary.authorizationStatusToReturn = .denied

            let expectation = self.expectation(description: "SaveResult")

            let movieURL = URL(fileURLWithPath: "file://test.mov")
            let stillImageData = Data()
            let mediaURL = try Media.URL<LivePhoto>(url: movieURL)
            let data = CapturedPhotoData(stillImageData: stillImageData, movieURL: mediaURL)

            var result: Result<LivePhoto, Error>?
            try LivePhoto.save(data: data) { res in
                result = res
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1)

            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? PermissionError, .denied)
            case .none:
                XCTFail("Invalid result")
            default: ()
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    #endif
}
