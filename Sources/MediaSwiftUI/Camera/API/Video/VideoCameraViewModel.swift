//
//  VideoCameraViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 19/02/2023.
//

#if os(macOS) || os(iOS)
import AVFoundation
import Combine
import Foundation
import MediaCore
import SwiftUI

@available(macCatalyst 14, *)
public final class VideoCameraViewModel: ObservableObject {
    enum CaptureState {
        case recording
        case paused
        case idle
    }

    private let outputDirectory: URL
    private let cameras: [AVCaptureDevice]
    private let captureSettings: AVCapturePhotoSettings
    private let output: AVCaptureMovieFileOutput
    private let videoRecorder: VideoRecorder
    private let selection: Binding<Result<Media.URL<Video>, Error>?>
    private let backgroundQueue: DispatchQueue

    let captureSession: AVCaptureSession

    @Published private(set) var state: CaptureState = .idle
    @Published private(set) var isCapturedVideoAvailable = false
    @Published private(set) var isFlashActive: Bool = false
    @Published private(set) var videoURL: URL?
    @Published private(set) var capturedVideoURL: Media.URL<Video>?

    init(
        outputDirectory: URL,
        cameras: [AVCaptureDevice],
        captureSession: AVCaptureSession,
        captureSettings: AVCapturePhotoSettings,
        output: AVCaptureMovieFileOutput,
        selection: Binding<Result<Media.URL<Video>, Error>?>
    ) {
        self.outputDirectory = outputDirectory
        self.cameras = cameras
        self.captureSession = captureSession
        self.captureSettings = captureSettings
        self.output = output
        self.videoRecorder = VideoRecorder(videoOutput: output)
        self.selection = selection
        backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    }
}

// MARK: - Internal API

@available(macCatalyst 14, *)
extension VideoCameraViewModel {
    func startVideoPreview() {
        backgroundQueue.async {
            self.captureSession.startRunning()
        }
    }

    @available(macOS 13, *)
    func toggleFlashMode() {
        isFlashActive.toggle()
        captureSettings.flashMode = isFlashActive ? .on : .off
    }

    func toggleCamera() {
        guard let lastCaptureDevice = captureSession.inputs.last as? AVCaptureDeviceInput else {
            return
        }

        guard let nextCamera = cameras.first(where: { $0.uniqueID != lastCaptureDevice.device.uniqueID }) else {
            return
        }

        do {
            captureSession.removeInput(lastCaptureDevice)
            try captureSession.addDevice(device: nextCamera)
        } catch {
            // Readd the last capture device as input on failure
            captureSession.addInput(lastCaptureDevice)
        }
    }

    func record() {
        guard state == .idle else {
            return
        }

        state = .recording

        let recordToURL = outputDirectory.appendingPathComponent("\(UUID().uuidString).mov")

        reset()

        videoRecorder.start(recordTo: recordToURL) { result in
            switch result {
            case .success(let url):
                self.videoURL = url
                self.capturedVideoURL = try? Media.URL(url: url)
                self.isCapturedVideoAvailable = self.capturedVideoURL != nil
            case .failure:
                self.videoURL = nil
            }

            self.state = .idle
        }
    }

    @available(iOS, unavailable)
    func pause() {
        guard state == .recording else {
            return
        }

        videoRecorder.pause()

        state = .paused
    }

    @available(iOS, unavailable)
    func resume() {
        guard state == .paused else {
            return
        }

        videoRecorder.resume()

        state = .recording
    }

    func stop() {
        videoRecorder.stop()
    }

    func finish() {
        if videoURL == nil {
            reset()
            dismiss()
        } else {
            reset()
        }
    }

    func useCapturedVideo() {
        if let capturedVideoURL = capturedVideoURL {
            selection.wrappedValue = .success(capturedVideoURL)
            finish()
        }
    }

    func onDisappear() {
        reset()
        backgroundQueue.async {
            self.captureSession.stopRunning()
        }
    }
}

// MARK: - Private

@available(macCatalyst 14, *)
private extension VideoCameraViewModel {
    func reset() {
        videoURL = nil
        capturedVideoURL = nil
        isCapturedVideoAvailable = false
    }

    func dismiss() {
        backgroundQueue.async {
            self.captureSession.stopRunning()
        }
    }
}
#endif
