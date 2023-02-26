//
//  VideoCameraViewModel+make.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 19/02/2023.
//

#if os(macOS)
import AVKit
import Foundation
import MediaCore
import SwiftUI

// MARK: - API

extension VideoCameraViewModel {
    /// Creates a camera view model instance using the given selection binding.
    ///
    /// - Parameter fileManager: The file manager which should be used, defaults to `default`.
    /// - Parameter selection: A binding which represents the live photo camera result.
    ///
    /// - Returns: A camera view model instance.
    public static func make(
        fileManager: FileManager = .default,
        selection: Binding<Result<Media.URL<Video>, Error>?>
    ) throws -> VideoCameraViewModel {
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

        // TODO: allow customization of session preset from the outside
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080

        let videoOutput = AVCaptureMovieFileOutput()
        try captureSession.addOutput(output: videoOutput)

//        videoOutput.isHighResolutionCaptureEnabled = true

        // TODO: allow customization of video codec from the outside
        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.h264])
        // Error: settings.processedFileType must be present in self.availablePhotoFileTypes

        captureSession.commitConfiguration()

        return VideoCameraViewModel(
            fileManager: fileManager,
            cameras: captureDevices,
            captureSession: captureSession,
            captureSettings: captureSettings,
            output: videoOutput,
            selection: selection
        )
    }
}
#endif
