//
//  CameraViewModel+make.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15/07/2022.
//

import AVKit
import Foundation
import MediaCore

// MARK: - API

@available(iOS 13, *)
@available(macCatalyst 14, *)
extension CameraViewModel {
    /// Creates a camera view model instance using the given completion block.
    ///
    /// - Parameter completion: A closure which gets the `URL` of the captured `LivePhoto` on `success` or `Error` on `failure`.
    /// - Returns: A camera view model instance.
    public static func make(
        _ completion: @escaping LivePhotoDataCompletion
    ) throws -> CameraViewModel {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        try captureSession.addDefaultAudioDevice()

        var cameraFound = false

        do {
            let frontCameraDevice: AVCaptureDevice = try .videoCamera(position: .front)
            try captureSession.addDevice(device: frontCameraDevice)
            cameraFound = true
        } catch {
            cameraFound = false
        }

        do {
            let backCameraDevice: AVCaptureDevice = try .videoCamera(position: .back)
            try captureSession.addDevice(device: backCameraDevice)
            cameraFound = true
        } catch {
            if !cameraFound {
                throw error
            }
        }

        captureSession.sessionPreset = .photo

        let photoOutput = AVCapturePhotoOutput()
        try captureSession.addOutput(output: photoOutput)

        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported

//        let availablePhotoFileTypes = photoOutput.availablePhotoFileTypes

        #if !os(macOS)
        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        #else
        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hvc1])
        #endif
        let outputDirectory = FileManager.default.cachesDirectory
        captureSettings.livePhotoMovieFileURL = outputDirectory.appendingPathComponent("\(UUID().uuidString).mov")

        captureSession.commitConfiguration()

        return CameraViewModel(
            captureSession: captureSession,
            captureSettings: captureSettings,
            output: photoOutput,
            completion
        )
    }
}
