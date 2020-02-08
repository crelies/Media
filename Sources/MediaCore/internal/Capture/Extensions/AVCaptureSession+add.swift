//
//  AVCaptureSession+add.swift
//  
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

// TODO: public
@available(iOS 10, *)
@available(tvOS, unavailable)
public extension AVCaptureSession {
    func addDevice(device: AVCaptureDevice) throws {
        let input = try AVCaptureDeviceInput(device: device)
        guard canAddInput(input) else { throw AVCaptureSession.Error.cannotAddInput(input) }
        addInput(input)
    }

    func addOutput(output: AVCaptureOutput) throws {
        guard canAddOutput(output) else { throw AVCaptureSession.Error.cannotAddOutput(output) }
        addOutput(output)
    }

    func addDefaultAudioDevice() throws {
        guard let device = AVCaptureDevice.default(for: .audio) else { throw AVCaptureSession.Error.noDefaultAudioDevice }
        try addDevice(device: device)
    }
}
