//
//  PhotoTests.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

#if canImport(UIKit)
@testable import MediaCore
import Photos
import XCTest

extension Photo {
    static var assetChangeRequest: AssetChangeRequest.Type = MockPHAssetChangeRequest.self
}

final class PhotoTests: XCTestCase {
    let mockAsset = MockPHAsset()
    lazy var photo = Photo(phAsset: mockAsset)
    let mockPHObjectPlaceholder = MockPHObjectPlaceholder()
    let mockImageManager = MockImageManager()

    override func setUp() {
        PHAssetChanger.photoLibrary = MockPhotoLibrary()
        Media.photoLibrary = MockPhotoLibrary.self
        MockPhotoLibrary.authorizationStatusToReturn = .authorized
        MockPhotoLibrary.performChangesSuccess = true
        MockPhotoLibrary.performChangesError = nil
        Photo.imageManager = mockImageManager
        mockPHObjectPlaceholder.localIdentifierToReturn = ""
        MockPHAssetChangeRequest.placeholderForCreatedAssetToReturn = mockPHObjectPlaceholder
        PHAssetFetcher.asset = MockPHAsset.self
        MockPHAsset.fetchResult.mockAssets.removeAll()
        mockAsset.localIdentifierToReturn = ""
        mockAsset.mediaTypeToReturn = .unknown
        mockAsset.mediaSubtypesToReturn = []
        mockAsset.contentEditingInputToReturn = nil

        mockImageManager.requestImageToReturn = nil
        mockImageManager.requestImageDataAndOrientationToReturn = nil

        photo.phAssetWrapper.value = mockAsset
    }

    @available(iOS 11, *)
    @available(tvOS 11, *)
    func testSaveURLFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = Media.Error.unknown

        let expectation = self.expectation(description: "SaveURLResult")

        do {
            let url = URL(fileURLWithPath: "file://test.\(Photo.FileType.jpg.pathExtensions.first!)")
            let mediaURL: Media.URL<Photo> = try Media.URL(url: url)

            var result: Result<Photo, Error>?
            Photo.save(mediaURL, { res in
                result = res
                expectation.fulfill()
            })

            waitForExpectations(timeout: 1)

            switch result {
            case .failure(let error):
                XCTAssertEqual(error as? Media.Error, .unknown)
            default:
                XCTFail("Invalid photo save URL result")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testSaveUIImageFailure() {
        MockPhotoLibrary.performChangesSuccess = false
        MockPhotoLibrary.performChangesError = Media.Error.unknown

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
            XCTAssertEqual(error as? Media.Error, .unknown)
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
        MockPhotoLibrary.performChangesError = Media.Error.unknown

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
            XCTAssertEqual(error as? Media.Error, .unknown)
        default:
            XCTFail("Invalid photo favorite result")
        }
    }

    func testSubtypes() {
        mockAsset.mediaSubtypesToReturn = [.photoHDR]
        let subtypes = photo.subtypes
        XCTAssertEqual(subtypes.count, 1)
    }

    func testMetadata() {
        XCTAssertNotNil(photo.metadata)
    }

    func testPropertiesSuccess() {
        do {
            let url = try createMockImage()

            let contentEditingInput = MockPHContentEditingInput()
            contentEditingInput.fullSizeImageURLToReturn = url
            mockAsset.contentEditingInputToReturn = contentEditingInput

            let expectation = self.expectation(description: "PropertiesResult")

            var res: Result<Photo.Properties, Swift.Error>?
            photo.properties { result in
                res = result
                expectation.fulfill()
            }

            waitForExpectations(timeout: 1)

            let properties = try res?.get()
            XCTAssertNotNil(properties)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPropertiesFailure() {
        photo.phAssetWrapper.value = nil

        let expectation = self.expectation(description: "PropertiesResult")

        var res: Result<Photo.Properties, Swift.Error>?
        photo.properties { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch res {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, Media.Error.noUnderlyingPHAssetFound)
        default:
            XCTFail("Invalid result")
        }
    }

    func testPropertiesMissingFullSizeImageURL() {
        let contentEditingInput = MockPHContentEditingInput()
        mockAsset.contentEditingInputToReturn = contentEditingInput

        let expectation = self.expectation(description: "PropertiesResult")

        var res: Result<Photo.Properties, Swift.Error>?
        photo.properties { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch res {
        case .failure(let error):
            XCTAssertEqual(error as? Photo.Error, Photo.Error.missingFullSizeImageURL)
        default:
            XCTFail("Invalid result")
        }
    }

    func testDataSuccess() {
        let expectedData = Data()
        mockImageManager.requestImageDataAndOrientationToReturn = expectedData

        let expectation = self.expectation(description: "DataResult")

        var res: Result<Data, Error>?
        photo.data { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        do {
            let data = try res?.get()
            XCTAssertEqual(data, expectedData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDataFailure() {
        photo.phAssetWrapper.value = nil

        let expectation = self.expectation(description: "DataResult")

        var res: Result<Data, Error>?
        photo.data { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch res {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, Media.Error.noUnderlyingPHAssetFound)
        default:
            XCTFail("Invalid result")
        }
    }

    func testUIImageSuccess() {
        let expectedImage = UIImage()
        mockImageManager.requestImageToReturn = expectedImage

        let targetSize = CGSize(width: 20, height: 20)
        let contentMode: PHImageContentMode = .aspectFit

        let expectation = self.expectation(description: "UIImageResult")

        var res: Result<Media.DisplayRepresentation<UIImage>, Error>?
        photo.uiImage(targetSize: targetSize, contentMode: contentMode) { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        do {
            let image = try res?.get()
            XCTAssertEqual(image?.value, expectedImage)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testUIImageFailure() {
        photo.phAssetWrapper.value = nil

        let targetSize = CGSize(width: 20, height: 20)
        let contentMode: PHImageContentMode = .aspectFit

        let expectation = self.expectation(description: "UIImageResult")

        var res: Result<Media.DisplayRepresentation<UIImage>, Error>?
        photo.uiImage(targetSize: targetSize, contentMode: contentMode) { result in
            res = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch res {
        case .failure(let error):
            XCTAssertEqual(error as? Media.Error, Media.Error.noUnderlyingPHAssetFound)
        default:
            XCTFail("Invalid result")
        }
    }

    func testWithIdentifierFound() {
        do {
            let localIdentifier = UUID().uuidString
            mockAsset.localIdentifierToReturn = localIdentifier
            mockAsset.mediaTypeToReturn = .image
            MockPHAsset.fetchResult.mockAssets = [mockAsset]

            let identifier = Media.Identifier<Photo>(localIdentifier: localIdentifier)
            let photo = try Photo.with(identifier: identifier)
            XCTAssertNotNil(photo)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testWithIdentifierNotFound() {
        do {
            let localIdentifier = UUID().uuidString
            let identifier = Media.Identifier<Photo>(localIdentifier: localIdentifier)
            let photo = try Photo.with(identifier: identifier)
            XCTAssertNil(photo)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDeleteSuccess() {
        let expectation = self.expectation(description: "DeleteResult")

        var result: Result<Void, Error>?
        photo.delete { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .failure(let error):
            XCTFail("\(error)")
        default:
            XCTAssertNil(photo.phAssetWrapper.value)
        }
    }

    func testDeleteFailure() {
        let expectation = self.expectation(description: "DeleteResult")

        photo.phAssetWrapper.value = nil

        var result: Result<Void, Error>?
        photo.delete { res in
            result = res
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        switch result {
        case .success:
            XCTFail("Invalid result")
        default:
            XCTAssertNil(photo.phAssetWrapper.value)
        }
    }
}
#endif
