//
//  AVCaptureDevice+devices.swift
//  
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

@available(iOS 10, *)
extension AVCaptureDevice {
    static func backVideoCamera() throws -> AVCaptureDevice {
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

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .back) {
            return device
        }

        throw Error.noBackVideoCamera
    }
}
