//
//  VideoRecorder.swift
//  MediaCore
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
public final class VideoRecorder: NSObject {
    private let videoOutput: AVCaptureMovieFileOutput
    private var completion: ResultURLCompletion?

    public init(videoOutput: AVCaptureMovieFileOutput) {
        self.videoOutput = videoOutput
    }
}

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
extension VideoRecorder {
    public func start(recordTo url: URL, completion: @escaping ResultURLCompletion) {
        self.completion = completion
        videoOutput.stopRecording()
        videoOutput.startRecording(to: url, recordingDelegate: self)
    }

    @available(iOS, unavailable)
    @available(macCatalyst, unavailable)
    public func pause() {
        videoOutput.pauseRecording()
    }

    @available(iOS, unavailable)
    @available(macCatalyst, unavailable)
    public func resume() {
        videoOutput.resumeRecording()
    }

    public func stop() {
        videoOutput.stopRecording()
    }
}

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
extension VideoRecorder: AVCaptureFileOutputRecordingDelegate {
    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didStartRecordingTo fileURL: URL,
        from connections: [AVCaptureConnection]
    ) {
        // TODO: ?
    }
    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        completion?(.success(outputFileURL))
    }

    #if os(macOS)
    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didPauseRecordingTo fileURL: URL,
        from connections: [AVCaptureConnection]
    ) {
        // TODO: ?
    }

    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didResumeRecordingTo fileURL: URL,
        from connections: [AVCaptureConnection]
    ) {
        // TODO: ?
    }
    #endif
}
