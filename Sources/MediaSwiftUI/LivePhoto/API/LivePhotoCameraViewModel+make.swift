//
//  LivePhotoCameraViewModel+make.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15/07/2022.
//

#if !os(tvOS)
import AVKit
import Foundation
import MediaCore
import SwiftUI

// MARK: - API

@available(iOS 13, *)
@available(macCatalyst 14, *)
extension LivePhotoCameraViewModel {
    /// Creates a camera view model instance using the given completion block.
    ///
    /// - Parameter selection: A binding which represents the live photo camera result.
    ///
    /// - Returns: A camera view model instance.
    public static func make(
        selection: Binding<Result<LivePhotoData, Error>?>
    ) throws -> LivePhotoCameraViewModel {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        #if !targetEnvironment(simulator)
        try captureSession.addDefaultAudioDevice()
        #endif

        var captureDevices: [AVCaptureDevice] = []

        do {
            let frontCameraDevice: AVCaptureDevice = try .videoCamera(position: .front)
            captureDevices.append(frontCameraDevice)
            try captureSession.addDevice(device: frontCameraDevice)
        } catch {}

        do {
            let backCameraDevice: AVCaptureDevice = try .videoCamera(position: .back)
            captureDevices.append(backCameraDevice)
            try captureSession.addDevice(device: backCameraDevice)
        } catch {
            if captureDevices.isEmpty {
                #if !targetEnvironment(simulator)
                throw error
                #endif
            }
        }

        captureSession.sessionPreset = .photo

        let photoOutput = AVCapturePhotoOutput()
        try captureSession.addOutput(output: photoOutput)

        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported

        #if !os(macOS)
        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        #else
        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hvc1])
        #endif
        let outputDirectory = FileManager.default.cachesDirectory
        captureSettings.livePhotoMovieFileURL = outputDirectory.appendingPathComponent("\(UUID().uuidString).mov")

        captureSession.commitConfiguration()

        return LivePhotoCameraViewModel(
            cameras: captureDevices,
            captureSession: captureSession,
            captureSettings: captureSettings,
            output: photoOutput,
            selection: selection
        )
    }
}
#endif
