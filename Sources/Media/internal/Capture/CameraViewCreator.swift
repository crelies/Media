//
//  CameraViewCreator.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

#if os(iOS)
import AVFoundation
import SwiftUI

@available(iOS 13, *)
struct CameraViewCreator {
    static func livePhoto(_ completion: @escaping LivePhotoDataCompletion) throws -> some View {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        try captureSession.addDefaultAudioDevice()

        let cameraDevice: AVCaptureDevice = try .backVideoCamera()
        try captureSession.addDevice(device: cameraDevice)

        captureSession.sessionPreset = .photo

        let photoOutput = AVCapturePhotoOutput()
        try captureSession.addOutput(output: photoOutput)

        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported

        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        let outputDirectory = FileManager.default.cachesDirectory
        captureSettings.livePhotoMovieFileURL = outputDirectory.appendingPathComponent("\(UUID().uuidString).mov")

        captureSession.commitConfiguration()

        return CameraView(captureSession: captureSession,
                          captureSettings: captureSettings,
                          output: photoOutput,
                          completion)
    }
}
#endif
