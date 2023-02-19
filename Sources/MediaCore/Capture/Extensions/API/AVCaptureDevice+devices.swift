//
//  AVCaptureDevice+devices.swift
//  MediaCore
//
//  Created by Christian Elies on 19.01.20.
//

#if !os(tvOS)
import AVFoundation

@available(iOS 10, *)
@available(macCatalyst 14, *)
public extension AVCaptureDevice {
    /// Looks for a back video camera and returns it if found
    ///
    /// - Parameter position: The position of video camera to request relative to system hardware (front- or back-facing). Pass AVCaptureDevice.Position.unspecified to search for devices regardless of position. Default is `back`.
    ///
    /// - Throws: an error if no back video camera was found
    /// - Returns: an instance of `AVCaptureDevice` representing a back video camera
    ///
    static func videoCamera(position: AVCaptureDevice.Position = .back) throws -> AVCaptureDevice {
        #if !os(macOS)
        if #available(iOS 13, *) {
            if let device = AVCaptureDevice.default(
                .builtInTripleCamera,
                for: .video,
                position: position
            ) {
                return device
            } else if let device = AVCaptureDevice.default(
                .builtInDualWideCamera,
                for: .video,
                position: position
            ) {
                return device
            }
        }

        if #available(iOS 10.2, *) {
            if let device = AVCaptureDevice.default(
                .builtInDualCamera,
                for: .video,
                position: position
            ) {
                return device
            }
        }
        #endif

        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ) {
            return device
        }

        throw Error.noBackVideoCamera
    }
}
#endif
