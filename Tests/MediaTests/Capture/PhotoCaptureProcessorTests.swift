//
//  PhotoCaptureProcessorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.02.20.
//

@testable import MediaCore
import XCTest

@available(iOS 10, *)
final class PhotoCaptureProcessorTests: XCTestCase {
    let captureProcessorDelegate = MockCaptureProcessorDelegate()
    lazy var photoCaptureProcessor: PhotoCaptureProcessor = {
        let processor = PhotoCaptureProcessor()
        processor.delegate = captureProcessorDelegate
        return processor
    }()

    override func setUpWithError() throws {
        captureProcessorDelegate.reset()
    }

    func testPhotoOutput() throws {

    }
}
