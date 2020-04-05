//
//  PhotoKitDictionaryTests.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

@testable import MediaCore
#if canImport(UIKit)
import UIKit
#endif
import XCTest

final class PhotoKitDictionaryTests: XCTestCase {
    var dictionary: [UIImagePickerController.InfoKey: Any] = [:]

    override func setUp() {
        dictionary.removeAll()
    }

    func testMediaType() {
        let expectedMediaType: UIImagePickerController.MediaType = .image

        dictionary[.mediaType] = expectedMediaType.cfString

        XCTAssertEqual(dictionary.mediaType, expectedMediaType)
    }

    @available(iOS 11, *)
    func testPHAsset() {
        XCTAssertNil(dictionary.phAsset)
    }

    @available(iOS 11, *)
    func testImageURL() {
        let imageURL = URL(fileURLWithPath: "file://image.jpeg")

        dictionary[.imageURL] = imageURL

        XCTAssertEqual(dictionary.imageURL, imageURL)
    }

    #if canImport(UIKit)
    func testOriginalImage() {
        let image = UIImage()

        dictionary[.originalImage] = image

        XCTAssertEqual(dictionary.originalImage, image)
    }
    #endif

    func testMediaURL() {
        let mediaURL = URL(fileURLWithPath: "file://test.mov")

        dictionary[.mediaURL] = mediaURL

        XCTAssertEqual(dictionary.mediaURL, mediaURL)
    }

    func testPHLivePhoto() {
        XCTAssertNil(dictionary.phLivePhoto)
    }
}
