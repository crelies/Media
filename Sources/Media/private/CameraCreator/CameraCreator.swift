//
//  CameraCreator.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import AVFoundation

struct CameraCreator {
    static var backVideoCameraDevice: AVCaptureDevice? {
        if #available(iOS 13, *) {
            if let device = AVCaptureDevice.default(.builtInTripleCamera,
                                                    for: .video,
                                                    position: .back) {
                return device

            } else if let device = AVCaptureDevice.default(.builtInDualWideCamera,
                                                           for: .video,
                                                           position: .back) {
                return device
            }
        }

        if #available(iOS 10.2, *) {
            if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                    for: .video,
                                                    position: .back) {
                return device
            }
        }

        if #available(iOS 10.0, *) {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: .video, position: .back) {
                return device
            }
        }

        return nil
    }
}

@available(iOS 13, *)
extension CameraCreator {
    static func livePhoto(_ completion: @escaping (Result<(Data, URL), Swift.Error>) -> Void) throws -> PhotoCameraSwiftUIView {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()

        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { throw Error.noAudioDevice }
        let audioInputDevice = try AVCaptureDeviceInput(device: audioDevice)
        guard captureSession.canAddInput(audioInputDevice) else { throw Error.cannotAddInput(audioInputDevice) }

        guard let cameraDevice = backVideoCameraDevice else { throw Error.noBackVideoCamera }
        let videoInputDevice = try AVCaptureDeviceInput(device: cameraDevice)
        guard captureSession.canAddInput(videoInputDevice) else { throw Error.cannotAddInput(videoInputDevice) }

        captureSession.addInput(audioInputDevice)
        captureSession.addInput(videoInputDevice)

        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { throw Error.cannotAddOutput(photoOutput) }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)

        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported

        captureSession.commitConfiguration()
        captureSession.startRunning()

        let livePhotoCaptureProcessor = LivePhotoCaptureProcessor(completion)
        let cameraPreview = PhotoCameraSwiftUIView(captureSession: captureSession,
                                                   output: photoOutput,
                                                   captureProcessor: livePhotoCaptureProcessor)
        return cameraPreview
    }
}
