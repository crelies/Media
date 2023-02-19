//
//  VideoCameraViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 19/02/2023.
//

#if os(macOS)
import AVFoundation
import Combine
import Foundation
import MediaCore
import SwiftUI

public final class VideoCameraViewModel: ObservableObject {
    private let cameras: [AVCaptureDevice]
    private let captureSettings: AVCapturePhotoSettings
    private let output: AVCaptureMovieFileOutput
    private let videoRecorder: VideoRecorder
    private let selection: Binding<Result<CapturedPhotoData, Error>?>
    private let backgroundQueue: DispatchQueue

    let captureSession: AVCaptureSession

    @Published private(set) var isRecording = false
    @Published private(set) var isCapturedVideoAvailable = false
    @Published private(set) var isFlashActive: Bool = false
    @Published private(set) var videoURL: URL?
    @Published private(set) var capturedPhotoData: CapturedPhotoData?

    init(
        cameras: [AVCaptureDevice],
        captureSession: AVCaptureSession,
        captureSettings: AVCapturePhotoSettings,
        output: AVCaptureMovieFileOutput,
        selection: Binding<Result<CapturedPhotoData, Error>?>
    ) {
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
        guard !isRecording else {
            return
        }

        // TODO: improve this
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        isRecording = true

        let recordToURL = url.appendingPathComponent("\(UUID().uuidString).mov")

        reset()

        videoRecorder.start(recordTo: recordToURL) { result in
            // TODO:
            switch result {
            case .success(let url):
                self.videoURL = url
//                self.capturedPhotoData = CapturedPhotoData(stillImageData: data)
                self.isCapturedVideoAvailable = true
            case .failure:
                self.videoURL = nil
            }

            self.isRecording = false
        }
    }

    // TODO:
    func pause() {

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
        if let capturedPhotoData = capturedPhotoData {
            selection.wrappedValue = .success(capturedPhotoData)
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

private extension VideoCameraViewModel {
    func reset() {
        videoURL = nil
        capturedPhotoData = nil
        isCapturedVideoAvailable = false
    }

    func dismiss() {
        backgroundQueue.async {
            self.captureSession.stopRunning()
        }
    }
}
#endif
