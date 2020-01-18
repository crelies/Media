//
//  CaptureProcessor.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation

@available(iOS 10, *)
protocol CaptureProcessor: AVCapturePhotoCaptureDelegate {
    var delegate: CaptureProcessorDelegate? { get set }
}
