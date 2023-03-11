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
/// A service for recording video.
public final class VideoRecorder: NSObject {
    private let videoOutput: AVCaptureMovieFileOutput
    private var completion: ResultURLCompletion?

    /// Initializes the recorder with the given video output.
    ///
    /// - Parameter videoOutput: A capture output that records video and audio to a QuickTime movie file.
    public init(videoOutput: AVCaptureMovieFileOutput) {
        self.videoOutput = videoOutput
    }
}

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
extension VideoRecorder {
    /// Starts the recording. Executes the given completion closure if finished.
    ///
    /// Stops a previous recording on the underlying output.
    ///
    /// - Parameters:
    ///   - url: An object specifying the output file URL.
    ///   - completion: A closure which is executed after the recording finished.
    public func start(recordTo url: URL, completion: @escaping ResultURLCompletion) {
        self.completion = completion
        videoOutput.stopRecording()
        videoOutput.startRecording(to: url, recordingDelegate: self)
    }

    @available(iOS, unavailable)
    @available(macCatalyst, unavailable)
    /// Pauses recording to the current output file.
    public func pause() {
        videoOutput.pauseRecording()
    }

    @available(iOS, unavailable)
    @available(macCatalyst, unavailable)
    /// Resumes recording to the current output file after it was previously paused using `pause()`.
    public func resume() {
        videoOutput.resumeRecording()
    }

    /// Tells the receiver to stop recording to the current file.
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
