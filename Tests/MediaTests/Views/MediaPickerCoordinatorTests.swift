//
//  MediaPickerCoordinatorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 04.02.20.
//

@testable import MediaSwiftUI
import XCTest

@available(iOS 13, *)
final class MediaPickerCoordinatorTests: XCTestCase {
    func testPhotoCameraMediaPickerValueSuccess() {
        let imageURL = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/test.jpeg")

        let mediaPickerValue = MediaPicker.Coordinator.mediaPickerValue(
            forSourceType: .camera,
            mediaType: .image,
            info: [UIImagePickerController.InfoKey.imageURL: imageURL])
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
