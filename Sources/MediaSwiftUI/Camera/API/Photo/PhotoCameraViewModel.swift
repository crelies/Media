//
//  PhotoCameraViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 04/05/2022.
//

#if !os(tvOS)
import AVFoundation
import Combine
import Foundation
import MediaCore
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@available(iOS 13, *)
@available(macCatalyst 14, *)
public final class PhotoCameraViewModel: ObservableObject {
    private let cameras: [AVCaptureDevice]
    private let captureSettings: AVCapturePhotoSettings
    private let output: AVCapturePhotoOutput
    private let photograph: Photograph
    private let selection: Binding<Result<CapturedPhotoData, Error>?>
    private let backgroundQueue: DispatchQueue

    let captureSession: AVCaptureSession

    @Published private(set) var isCapturedPhotoAvailable = false
    @Published private(set) var isFlashActive: Bool = false
    @Published private(set) var stillImageData: Data?
    @Published private(set) var capturedPhotoData: CapturedPhotoData?

    init(
        cameras: [AVCaptureDevice],
        captureSession: AVCaptureSession,
        captureSettings: AVCapturePhotoSettings,
        output: AVCapturePhotoOutput,
        selection: Binding<Result<CapturedPhotoData, Error>?>
    ) {
        self.cameras = cameras
        self.captureSession = captureSession
        self.captureSettings = captureSettings
        self.output = output
        self.photograph = Photograph(photoOutput: output, photoSettings: captureSettings)
        self.selection = selection
        backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    }
}

// MARK: - Internal API

@available(iOS 13, *)
@available(macCatalyst 14, *)
extension PhotoCameraViewModel {
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

        #if !os(macOS)
        output.isLivePhotoCaptureEnabled = output.isLivePhotoCaptureSupported
        #endif
    }

    func capture() {
        reset()

        photograph.shootPhoto(stillImageCompletion: { stillImageResult in
            switch stillImageResult {
            case .success(let data):
                self.stillImageData = data

                // With mac cameras currently (2023) only still images can be captured.
                #if os(macOS)
                self.capturedPhotoData = CapturedPhotoData(stillImageData: data)
                self.isCapturedPhotoAvailable = true
                #endif

            case .failure:
                self.stillImageData = nil
            }
        }, livePhotoCompletion: handleLivePhotoResult)
    }

    #if !os(macOS)
    func handleLivePhotoResult(_ result: Result<CapturedPhotoData, Error>) {
        switch result {
        case .success(let data):
            self.capturedPhotoData = data
            self.isCapturedPhotoAvailable = true
        case .failure:
            self.capturedPhotoData = nil
            self.isCapturedPhotoAvailable = false
        }
    }
    #else
    func handleLivePhotoResult(_ result: Result<Void, Error>) {
        // This is never called.
    }
    #endif

    func finish() {
        if stillImageData == nil {
            reset()
            dismiss()
        } else {
            reset()
        }
    }

    func useCapturedPhoto() {
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

@available(iOS 13, *)
@available(macCatalyst 14, *)
private extension PhotoCameraViewModel {
    func reset() {
        stillImageData = nil
        capturedPhotoData = nil
        isCapturedPhotoAvailable = false
    }

    func dismiss() {
        backgroundQueue.async {
            self.captureSession.stopRunning()
        }
    }
}
#endif
