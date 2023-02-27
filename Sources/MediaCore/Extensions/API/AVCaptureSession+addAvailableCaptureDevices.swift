//
//  AVCaptureSession+addAvailableCaptureDevices.swift
//  MediaCore
//
//  Created by Christian Elies on 27.02.23.
//

import AVKit

@available(macCatalyst 14, *)
@available(tvOS, unavailable)
extension AVCaptureSession {
    #if !os(tvOS)
    /// Adds available capture devices to the receiving capture session and returns them.
    ///
    /// - Returns: The capture devices added to the receiving capture session.
    public func addAvailableCaptureDevices() throws -> [AVCaptureDevice] {
        var captureDevices: [AVCaptureDevice] = []

        do {
            let frontCameraDevice: AVCaptureDevice = try .videoCamera(position: .front)
            captureDevices.append(frontCameraDevice)
            try addDevice(device: frontCameraDevice)
        } catch {}

        do {
            let backCameraDevice: AVCaptureDevice = try .videoCamera(position: .back)
            captureDevices.append(backCameraDevice)
            try addDevice(device: backCameraDevice)
        } catch {
            if captureDevices.isEmpty {
                #if !targetEnvironment(simulator)
                throw error
                #endif
            }
        }

        return captureDevices
    }
    #endif
}
