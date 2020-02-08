//
//  VideoRecorderTests.swift
//  MediaTests
//
//  Created by Christian Elies on 04.02.20.
//

@testable import MediaCore
import XCTest

@available(iOS 10, *)
final class VideoRecorderTests: XCTestCase {
    let videoOutput = MockAVCaptureMovieFileOutput()
    lazy var videoRecorder = VideoRecorder(videoOutput: videoOutput)

    func testRecording() {
        let expectation = self.expectation(description: "RecordingResult")

        let url = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/test.mov")

        var result: Result<URL, Error>?
        videoRecorder.start(recordTo: url) { res in
            result = res
            expectation.fulfill()
        }

        videoRecorder.stop()

        waitForExpectations(timeout: 1)

        do {
            let outputFileURL = try result?.get()
            XCTAssertNotNil(outputFileURL)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
