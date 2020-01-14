//
//  LivePhotoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 15.12.19.
//

@testable import Media
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

        if #available(OSX 10.15, *) {
            PHAssetChanger.photoLibrary = photoLibrary
        }

        livePhotoManager.livePhotoToReturn = nil
        livePhotoManager.infoToReturn = nil

        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil

        asset.localIdentifierToReturn = ""
        asset.mediaTypeToReturn = .audio
        asset.mediaSubtypesToReturn = .videoHighFrameRate

        MockPHAsset.fetchResult.mockAssets.removeAll()
    }

    #if !os(macOS)
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
        MockPhotoLibrary.performChangesError = MediaError.unknown

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
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid display representaiton result \(String(describing: result))")
        }
    }
    #endif

    @available(macOS 10.15, *)
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

    @available(macOS 10.15, *)
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

    @available(macOS 10.15, *)
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

    @available(macOS 10.15, *)
    func testFavoriteFailure() {
        let expectation = self.expectation(description: "FavoriteResult")

        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        var result: Result<Void, Error>?
        let isFavorite = false
        livePhoto.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid favorite result \(String(describing: result))")
        }
    }
}
