//
//  CameraCreator+Error.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import AVFoundation

@available(iOS 10, *)
extension CameraCreator {
    enum Error: Swift.Error {
        case cannotAddInput(_ input: AVCaptureDeviceInput)
        case cannotAddOutput(_ output: AVCapturePhotoOutput)
        case noAudioDevice
        case noBackVideoCamera
    }
}
