//
//  CameraViewModel.swift
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
public final class CameraViewModel: ObservableObject {
    private let captureSettings: AVCapturePhotoSettings
    private let output: AVCapturePhotoOutput
    private let photograph: Photograph
    private let completion: LivePhotoDataCompletion
    private let backgroundQueue: DispatchQueue

    let captureSession: AVCaptureSession

    @Published private(set) var isLivePhotoAvailable = false
    @Published private(set) var isFlashActive: Bool = false
    @Published private(set) var stillImageData: Data?
    @Published private(set) var livePhotoData: LivePhotoData?

    init(
        captureSession: AVCaptureSession,
        captureSettings: AVCapturePhotoSettings,
        output: AVCapturePhotoOutput,
        _ completion: @escaping LivePhotoDataCompletion
    ) {
        self.captureSession = captureSession
        self.captureSettings = captureSettings
        self.output = output
        self.photograph = Photograph(photoOutput: output, photoSettings: captureSettings)
        self.completion = completion
        backgroundQueue = DispatchQueue.global(qos: .userInitiated)
    }
}

// MARK: - Internal API

@available(iOS 13, *)
@available(macCatalyst 14, *)
extension CameraViewModel {
    func startVideoPreview() {
        backgroundQueue.async {
            self.captureSession.startRunning()
        }
    }

    func toggleFlashMode() {
        isFlashActive.toggle()
        captureSettings.flashMode = isFlashActive ? .on : .off
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
            completion(.success(livePhotoData))
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
private extension CameraViewModel {
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
