//
//  PhotoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

#if canImport(UIKit)
@testable import Media
import XCTest

final class PhotoTests: XCTestCase {
    let mockAsset = MockPHAsset()
    lazy var photo = Photo(phAsset: mockAsset)
    let mockPHObjectPlaceholder = MockPHObjectPlaceholder()

    override func setUp() {
        PHAssetChanger.photoLibrary = MockPhotoLibrary()
        Media.photoLibrary = MockPhotoLibrary.self
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
        Photo.assetChangeRequest = MockPHAssetChangeRequest.self
        mockPHObjectPlaceholder.localIdentifierToReturn = ""
        MockPHAssetChangeRequest.placeholderForCreatedAssetToReturn = mockPHObjectPlaceholder
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.localIdentifierToReturn = ""
        mockAsset.mediaTypeToReturn = .unknown
    }

    @available(iOS 11, *)
    @available(tvOS 11, *)
    func testSaveURLSuccess() {
        let localIdentifier = UUID().uuidString
        mockAsset.localIdentifierToReturn = localIdentifier
        mockAsset.mediaTypeToReturn = .image
        MockPHAsset.fetchResult.mockAssets = [mockAsset]

        mockPHObjectPlaceholder.localIdentifierToReturn = localIdentifier

        let expectation = self.expectation(description: "SaveURLResult")

        do {
            let url = URL(fileURLWithPath: "file://test.\(Photo.FileType.jpg.pathExtensions.first!)")
            let mediaURL: MediaURL<Photo> = try MediaURL(url: url)

            var result: Result<Photo, Error>?
            Photo.save(mediaURL, { res in
                result = res
                expectation.fulfill()
            })

            waitForExpectations(timeout: 1)

            switch result {
            case .success: ()
            default: ()
                // TODO:
//                XCTFail("Invalid photo save URL result")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @available(iOS 11, *)
    @available(tvOS 11, *)
    func testSaveURLFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        let expectation = self.expectation(description: "SaveURLResult")

        do {
            let url = URL(fileURLWithPath: "file://test.\(Photo.FileType.jpg.pathExtensions.first!)")
            let mediaURL: MediaURL<Photo> = try MediaURL(url: url)

            var result: Result<Photo, Error>?
            Photo.save(mediaURL, { res in
                result = res
                expectation.fulfill()
            })

            waitForExpectations(timeout: 1)

            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? MediaError, .unknown)
            default:
                XCTFail("Invalid photo save URL result")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @available(iOS 11, *)
    func testSaveUIImageSuccess() {
        let expectation = self.expectation(description: "SaveUIImageResult")

        let image = UIImage()
        var result: Result<Photo, Error>?
        Photo.save(image) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default: ()
            // TODO:
//                XCTFail("Invalid photo save UIImage result")
        }
    }

    func testSaveUIImageFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        let expectation = self.expectation(description: "SaveUIImageResult")

        let image = UIImage()
        var result: Result<Photo, Error>?
        Photo.save(image) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid photo save UIImage result")
        }
    }

    func testFavoriteSuccess() {
        let expectation = self.expectation(description: "PhotoFavoriteResult")

        let isFavorite = false
        var result: Result<Void, Error>?
        photo.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success: ()
        default:
            XCTFail("Invalid photo favorite result")
        }
    }

    func testFavoriteFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = MediaError.unknown

        let expectation = self.expectation(description: "PhotoFavoriteResult")

        let isFavorite = false
        var result: Result<Void, Error>?
        photo.favorite(isFavorite) { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error as? MediaError, .unknown)
        default:
            XCTFail("Invalid photo favorite result")
        }
    }
}
#endif
