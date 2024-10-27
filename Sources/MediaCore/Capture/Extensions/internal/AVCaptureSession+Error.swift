//
//  AVCaptureSession+Error.swift
//  MediaCore
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS 17, *)
extension AVCaptureSession {
    enum Error: Swift.Error {
        /// Thrown if the given input could not be added
        case cannotAddInput(_ input: AVCaptureDeviceInput)
        /// Thrown if the given output could not be added
        case cannotAddOutput(_ output: AVCaptureOutput)
        /// Thrown if there is no default audio device
        case noDefaultAudioDevice
    }
}
