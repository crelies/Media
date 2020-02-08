//
//  PhotographTests.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

import AVFoundation
@testable import MediaCore
import XCTest

@available(iOS 11, *)
final class PhotographTests: XCTestCase {
    let photoOutput = MockAVCapturePhotoOutput()
    let photoSettings = AVCapturePhotoSettings()
    lazy var photograph = Photograph(photoOutput: photoOutput, photoSettings: photoSettings)

    override func setUp() {
        Photograph.captureProcessor = MockCaptureProcessor.self

        MockCaptureProcessor.photoOutputDataToReturn = nil
        MockCaptureProcessor.livePhotoDataToReturn = nil

        photoOutput.livePhotoMovieURLToReturn = nil
    }

    func testShootPhoto() {
        do {
            let expectedData = Data()

            let url = URL(fileURLWithPath: "file://mock.mov")
            let movieURL = try Media.URL<LivePhoto>(url: url)
            let expectedLivePhotoData = LivePhotoData(stillImageData: expectedData, movieURL: movieURL)

            photoOutput.livePhotoMovieURLToReturn = url

            MockCaptureProcessor.photoOutputDataToReturn = expectedData
            MockCaptureProcessor.livePhotoDataToReturn = expectedLivePhotoData

            let stillImageExpectation = expectation(description: "StillImageCompletion")
            let livePhotoDataExpectation = expectation(description: "LivePhotoDataCompletion")

            var stillImageResult: Result<Data, Error>?
            var livePhotoResult: Result<LivePhotoData, Error>?

            photograph.shootPhoto(stillImageCompletion: { result in
                stillImageResult = result
                stillImageExpectation.fulfill()
            }) { result in
                livePhotoResult = result
                livePhotoDataExpectation.fulfill()
            }

            waitForExpectations(timeout: 2)

            let resultData = try stillImageResult?.get()
            let resultLivePhotoData = try livePhotoResult?.get()

            XCTAssertEqual(resultData, expectedData)
            XCTAssertEqual(resultLivePhotoData, expectedLivePhotoData)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
