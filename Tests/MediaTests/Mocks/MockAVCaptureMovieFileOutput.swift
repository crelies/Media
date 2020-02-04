//
//  MockAVCaptureMovieFileOutput.swift
//  MediaTests
//
//  Created by Christian Elies on 04.02.20.
//

import AVFoundation

final class MockAVCaptureMovieFileOutput: AVCaptureMovieFileOutput {
    private weak var recordingDelegate: AVCaptureFileOutputRecordingDelegate?
    private var outputURL: URL?

    override func startRecording(to outputFileURL: URL, recordingDelegate delegate: AVCaptureFileOutputRecordingDelegate) {
        self.outputURL = outputFileURL
        self.recordingDelegate = delegate
    }

    override func stopRecording() {
        if let outputFileURL = outputURL {
            recordingDelegate?.fileOutput(self, didFinishRecordingTo: outputFileURL, from: [], error: nil)
            recordingDelegate = nil
        }
    }
}
