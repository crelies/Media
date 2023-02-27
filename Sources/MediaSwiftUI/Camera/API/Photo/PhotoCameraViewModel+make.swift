//
//  PhotoCameraViewModel+make.swift
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
extension PhotoCameraViewModel {
    /// Creates a camera view model instance using the given selection binding.
    ///
    /// - Parameter fileManager: The file manager which should be used, defaults to `default`.
    /// - Parameter selection: A binding which represents the live photo camera result.
    ///
    /// - Returns: A camera view model instance.
    public static func make(
        fileManager: FileManager = .default,
        selection: Binding<Result<CapturedPhotoData, Error>?>
    ) throws -> PhotoCameraViewModel {
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

        let videoCodec: AVVideoCodecType? = videoCodec(
            // Read the property `availablePhotoCodecTypes` only after adding the photo capture output
            // to an AVCaptureSession object containing a video source.
            // If the photo capture output isn’t connected to
            // a session with a video source, this array is empty.
            availablePhotoCodecTypes: photoOutput.availablePhotoCodecTypes
        )
        var format: [String: Any] = [:]
        if let videoCodec = videoCodec {
            format = [AVVideoCodecKey: videoCodec]
        }

        let captureSettings = AVCapturePhotoSettings(format: format)

        #if !os(macOS)
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported

        let outputDirectory = fileManager.cachesDirectory
        captureSettings.livePhotoMovieFileURL = outputDirectory.appendingPathComponent("\(UUID().uuidString).mov")
        #else
        // Error: settings.processedFileType must be present in self.availablePhotoFileTypes
        #endif

        captureSession.commitConfiguration()

        return PhotoCameraViewModel(
            cameras: captureDevices,
            captureSession: captureSession,
            captureSettings: captureSettings,
            output: photoOutput,
            selection: selection
        )
    }

    private static func videoCodec(availablePhotoCodecTypes: [AVVideoCodecType]) -> AVVideoCodecType? {
        #if !os(macOS)
        return .hevc
        #else
        // TODO: [macOS] allow customization of codec for photo capture
        return .jpeg
        #endif
    }
}
#endif
