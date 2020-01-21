//
//  AVCaptureSession+Error.swift
//  
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

@available(iOS 10, *)
@available(tvOS, unavailable)
extension AVCaptureSession {
    enum Error: Swift.Error {
        case cannotAddInput(_ input: AVCaptureDeviceInput)
        case cannotAddOutput(_ output: AVCaptureOutput)
        case noDefaultAudioDevice
    }
}
