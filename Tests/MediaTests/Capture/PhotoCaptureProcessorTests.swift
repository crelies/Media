//
//  PhotoCaptureProcessorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.02.20.
//

@testable import MediaCore
import XCTest

@available(iOS 11, *)
final class PhotoCaptureProcessorTests: XCTestCase {
    let photoOutput = MockAVCapturePhotoOutput()
    let captureResolvedPhotoSettings = MockAVCaptureResolvedPhotoSettings()
    let capturePhoto = MockAVCapturePhoto()
    let captureProcessorDelegate = MockCaptureProcessorDelegate()
    lazy var photoCaptureProcessor: PhotoCaptureProcessor = {
        let processor = PhotoCaptureProcessor()
        processor.delegate = captureProcessorDelegate
        return processor
    }()

    override func setUp() {
        capturePhoto.fileDataRepresentationData = nil
        captureProcessorDelegate.reset()
    }

    func testPhotoOutputSuccess() {
        capturePhoto.fileDataRepresentationData = Data()

        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingPhoto: capturePhoto,
                                          error: nil)
        XCTAssertTrue(captureProcessorDelegate.didCapturePhotoCalled)
    }

    func testPhotoOutputMissingData() {
        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingPhoto: capturePhoto,
                                          error: nil)
        XCTAssertFalse(captureProcessorDelegate.didCapturePhotoCalled)
    }

    func testPhotoOutputFailure() {
        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingPhoto: capturePhoto,
                                          error: Media.Error.unknown)
        XCTAssertFalse(captureProcessorDelegate.didCapturePhotoCalled)
    }

    func testLivePhotoVideoPortionSuccess() {
        capturePhoto.fileDataRepresentationData = Data()

        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingPhoto: capturePhoto,
                                          error: nil)

        let movieURL = URL(fileURLWithPath: "file://test.mov")
        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingLivePhotoToMovieFileAt: movieURL,
                                          duration: .indefinite,
                                          photoDisplayTime: .positiveInfinity,
                                          resolvedSettings: captureResolvedPhotoSettings,
                                          error: nil)
        XCTAssertTrue(captureProcessorDelegate.didCaptureLivePhotoCalled)
    }

    func testLivePhotoVideoPortionMissingStillImageData() {
        let movieURL = URL(fileURLWithPath: "file://test.mov")
        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingLivePhotoToMovieFileAt: movieURL,
                                          duration: .indefinite,
                                          photoDisplayTime: .positiveInfinity,
                                          resolvedSettings: captureResolvedPhotoSettings,
                                          error: nil)
        XCTAssertFalse(captureProcessorDelegate.didCaptureLivePhotoCalled)
    }

    func testLivePhotoVideoPortionInvalidURL() {
        capturePhoto.fileDataRepresentationData = Data()

        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingPhoto: capturePhoto,
                                          error: nil)

        let movieURL = URL(fileURLWithPath: "file://test.jpg")
        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingLivePhotoToMovieFileAt: movieURL,
                                          duration: .indefinite,
                                          photoDisplayTime: .positiveInfinity,
                                          resolvedSettings: captureResolvedPhotoSettings,
                                          error: nil)
        XCTAssertFalse(captureProcessorDelegate.didCaptureLivePhotoCalled)
    }

    func testLivePhotoVideoPortionFailure() {
        let movieURL = URL(fileURLWithPath: "file://test.mov")
        photoCaptureProcessor.photoOutput(photoOutput,
                                          didFinishProcessingLivePhotoToMovieFileAt: movieURL,
                                          duration: .indefinite,
                                          photoDisplayTime: .positiveInfinity,
                                          resolvedSettings: captureResolvedPhotoSettings,
                                          error: Media.Error.unknown)
        XCTAssertFalse(captureProcessorDelegate.didCaptureLivePhotoCalled)
    }
}
