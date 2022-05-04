//
//  AVCaptureDevice+Error.swift
//  
//
//  Created by Christian Elies on 19.01.20.
//

import AVFoundation

@available(iOS 10, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
extension AVCaptureDevice {
    enum Error: Swift.Error {
        /// Thrown if there is no back video camera
        case noBackVideoCamera
    }
}
