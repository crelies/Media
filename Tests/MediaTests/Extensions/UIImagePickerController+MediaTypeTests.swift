//
//  UIImagePickerController+MediaTypeTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

#if canImport(UIKit) && !os(tvOS)
@testable import MediaCore
import MobileCoreServices
import XCTest

final class UIImagePickerController_MediaTypeTests: XCTestCase {
    func testImageCFString() {
        let mediaType: UIImagePickerController.MediaType = .image
        XCTAssertEqual(mediaType.cfString, .image)
    }

    func testLivePhotoCFString() {
        let mediaType: UIImagePickerController.MediaType = .livePhoto
        XCTAssertEqual(mediaType.cfString, .livePhoto)
    }

    func testMovieCFString() {
        let mediaType: UIImagePickerController.MediaType = .movie
        XCTAssertEqual(mediaType.cfString, .movie)
    }

    func testSuccessfulInit() {
        do {
            _ = try UIImagePickerController.MediaType(string: kUTTypeMovie as String)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testErrorOnInit() {
        do {
            _ = try UIImagePickerController.MediaType(string: "aaa")
            XCTFail("Successful init is unexpected")
        } catch {
            let error = error as? UIImagePickerController.MediaTypeError
            XCTAssertEqual(error, .unsupportedString)
        }
    }
}
#endif
