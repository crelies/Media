//
//  AVCaptureSession+add.swift
//  MediaCore
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
public extension AVCaptureSession {
    /// Adds the given device as an input to the receiver
    /// if `canAddInput` returns true
    ///
    /// - Parameter device: the device which should be added
    /// - Throws: an error if the input cannot be added
    ///
    func addDevice(device: AVCaptureDevice) throws {
        let input = try AVCaptureDeviceInput(device: device)
        guard canAddInput(input) else { throw AVCaptureSession.Error.cannotAddInput(input) }
        addInput(input)
    }

    /// Adds the given output to the receiver
    /// if `canAddOutput` returns true
    ///
    /// - Parameter output: the output which should be added
    /// - Throws: an error if the output cannot be added
    ///
    func addOutput(output: AVCaptureOutput) throws {
        guard canAddOutput(output) else { throw AVCaptureSession.Error.cannotAddOutput(output) }
        addOutput(output)
    }

    /// Adds the default audio device to the receiver
    /// if found
    ///
    /// - Throws: an error if there is no default audio device
    ///
    func addDefaultAudioDevice() throws {
        guard let device = AVCaptureDevice.default(for: .audio) else { throw AVCaptureSession.Error.noDefaultAudioDevice }
        try addDevice(device: device)
    }
}
