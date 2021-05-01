//
//  MediaPickerCoordinatorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 04.02.20.
//

#if !os(tvOS)
@testable import MediaSwiftUI
import XCTest

@available(iOS 13, *)
final class MediaPickerCoordinatorTests: XCTestCase {
    func testPhotoCameraMediaPickerValueSuccess() {
        let originalImage = UIImage()

        let mediaPickerValue = MediaPicker.Coordinator.mediaPickerValue(
            forSourceType: .camera,
            mediaType: .image,
            info: [UIImagePickerController.InfoKey.originalImage: originalImage])
        XCTAssertNotNil(mediaPickerValue)
    }

    func testPhotoCameraMediaPickerValueFailure() {
        let mediaPickerValue = MediaPicker.Coordinator.mediaPickerValue(
            forSourceType: .camera,
            mediaType: .image,
            info: [:])
        XCTAssertNil(mediaPickerValue)
    }

    func testVideoCameraMediaPickerValueSuccess() {
        let url = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/test.mov")

        let mediaPickerValue = MediaPicker.Coordinator.mediaPickerValue(
            forSourceType: .camera,
            mediaType: .movie,
            info: [UIImagePickerController.InfoKey.mediaURL: url])
        XCTAssertNotNil(mediaPickerValue)
    }

    func testVideoCameraMediaPickerValueFailure() {
        let mediaPickerValue = MediaPicker.Coordinator.mediaPickerValue(
            forSourceType: .camera,
            mediaType: .movie,
            info: [:])
        XCTAssertNil(mediaPickerValue)
    }

    func testLibraryImageMediaPickerValue() {
        // ph asset
        // image, movie
        // saved photos album, photo library
    }

    func testLibraryMovieMediaPickerValue() {

    }

    func testLivePhotoMediaPickerValue() {
        // ph asset, ph live photo
    }
}
#endif
