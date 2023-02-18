//
//  LivePhotoCameraViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 04/05/2022.
//

#if canImport(UIKit) && !os(tvOS)
import AVFoundation
import Combine
import Foundation
import MediaCore
import SwiftUI
import UIKit

@available(iOS 13, *)
@available(macCatalyst 14, *)
public final class LivePhotoCameraViewModel: ObservableObject {
    private let cameras: [AVCaptureDevice]
    private let captureSettings: AVCapturePhotoSettings
    private let output: AVCapturePhotoOutput
    private let photograph: Photograph
    private let selection: Binding<Result<LivePhotoData, Error>?>
    private let backgroundQueue: DispatchQueue

    let captureSession: AVCaptureSession

    @Published private(set) var isLivePhotoAvailable = false
    @Published private(set) var isFlashActive: Bool = false
    @Published private(set) var stillImageData: Data?
    @Published private(set) var livePhotoData: LivePhotoData?

    init(
        cameras: [AVCaptureDevice],
        captureSession: AVCaptureSession,
        captureSettings: AVCapturePhotoSettings,
        output: AVCapturePhotoOutput,
        selection: Binding<Result<LivePhotoData, Error>?>
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
extension LivePhotoCameraViewModel {
    func startVideoPreview() {
        backgroundQueue.async {
            self.captureSession.startRunning()
        }
    }

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

        output.isLivePhotoCaptureEnabled = output.isLivePhotoCaptureSupported
    }

    func capture() {
        reset()

        photograph.shootPhoto(stillImageCompletion: { stillImageResult in
            switch stillImageResult {
            case .success(let data):
                self.stillImageData = data
            case .failure:
                self.stillImageData = nil
            }
        }) { livePhotoResult in
            switch livePhotoResult {
            case .success(let data):
                self.livePhotoData = data
                self.isLivePhotoAvailable = true
            case .failure:
                self.livePhotoData = nil
                self.isLivePhotoAvailable = false
            }
        }
    }

    func finish() {
        if stillImageData == nil {
            reset()
            dismiss()
        } else {
            reset()
        }
    }

    func useLivePhoto() {
        if let livePhotoData = livePhotoData {
            selection.wrappedValue = .success(livePhotoData)
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
private extension LivePhotoCameraViewModel {
    func reset() {
        stillImageData = nil
        livePhotoData = nil
        isLivePhotoAvailable = false
    }

    func dismiss() {
        backgroundQueue.async {
            self.captureSession.stopRunning()
        }
    }
}
#endif
