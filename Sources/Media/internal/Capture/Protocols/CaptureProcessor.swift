//
//  CaptureProcessor.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation

@available(iOS 10, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
protocol CaptureProcessor: AVCapturePhotoCaptureDelegate where Self: NSObject {
    var delegate: CaptureProcessorDelegate? { get set }
}
