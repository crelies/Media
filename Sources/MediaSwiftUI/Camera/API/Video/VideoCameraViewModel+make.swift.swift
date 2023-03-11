//
//  VideoCameraViewModel+make.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 19/02/2023.
//

#if !os(tvOS)
import AVKit
import Foundation
import MediaCore
import SwiftUI

// MARK: - API

@available(macCatalyst 14, *)
extension VideoCameraViewModel {
    /// Presets that define standard configurations for a video capture session.
    public enum Preset {
        /// A preset suitable for capturing high-quality output.
        case high
        /// A preset suitable for capturing medium-quality output.
        case medium
        /// A preset suitable for capturing low-quality output.
        case low
        /// A preset suitable for capturing quarter HD quality (960 x 540 pixel) video output.
        case qHD960x540
        /// A preset suitable for capturing 720p quality (1280 x 720 pixel) video output.
        case hd1280x720
        /// A preset suitable for capturing 1080p-quality (1920 x 1080 pixels) video output.
        case hd1920x1080
        /// A preset suitable for capturing 2160p-quality (3840 x 2160 pixels) video output.
        case hd4K3840x2160
        /// A preset suitable for capturing 320 x 240 pixel video output.
        case qvga320x240
        /// A preset suitable for capturing VGA quality (640 x 480 pixel) video output.
        case vga640x480
        /// A preset suitable for capturing 960 x 540 quality iFrame H.264 video at about 30 Mbits/sec with AAC audio.
        case iFrame960x540
        /// A preset suitable for capturing 1280 x 720 quality iFrame H.264 video at about 40 Mbits/sec with AAC audio.
        case iFrame1280x720
        /// A preset suitable for capturing CIF quality (352 x 288 pixel) video output.
        case cif352x288

        var sessionPreset: AVCaptureSession.Preset {
            switch self {
            case .high:
                return .high
            case .medium:
                return .medium
            case .low:
                return .low
            case .qHD960x540:
                return .qHD960x540
            case .hd1280x720:
                return .hd1280x720
            case .hd1920x1080:
                return .hd1920x1080
            case .hd4K3840x2160:
                return .hd4K3840x2160
            case .qvga320x240:
                return .qvga320x240
            case .vga640x480:
                return .vga640x480
            case .iFrame960x540:
                return .iFrame960x540
            case .iFrame1280x720:
                return .iFrame1280x720
            case .cif352x288:
                return .cif352x288
            }
        }
    }

    /// Creates a camera view model instance using the given selection binding.
    ///
    /// - Parameter fileManager: The file manager which should be used, defaults to `default`.
    /// - Parameter selection: A binding which represents the live photo camera result.
    /// - Parameter preset: A preset value that indicates the quality level or bit rate of the video output, defaults to `.hd1920x1080`.
    /// - Parameter videoCodec: The codec to use for video capture, defaults to `.h264`.
    ///
    /// - Returns: A camera view model instance.
    public static func make(
        fileManager: FileManager = .default,
        selection: Binding<Result<Media.URL<Video>, Error>?>,
        preset: Preset = .hd1920x1080,
        videoCodec: AVVideoCodecType = .h264
    ) throws -> VideoCameraViewModel {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        #if !targetEnvironment(simulator)
        try captureSession.addDefaultAudioDevice()
        #endif

        let captureDevices = try captureSession.addAvailableCaptureDevices()

        let videoOutput = AVCaptureMovieFileOutput()
        try captureSession.addOutput(output: videoOutput)

        captureSession.sessionPreset = preset.sessionPreset

        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: videoCodec])
        // Error: settings.processedFileType must be present in self.availablePhotoFileTypes

        captureSession.commitConfiguration()

        // TODO: custom directory from the outside?
        guard let outputDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CocoaError(.fileNoSuchFile)
        }

        return VideoCameraViewModel(
            outputDirectory: outputDirectory,
            cameras: captureDevices,
            captureSession: captureSession,
            captureSettings: captureSettings,
            output: videoOutput,
            selection: selection
        )
    }
}
#endif
