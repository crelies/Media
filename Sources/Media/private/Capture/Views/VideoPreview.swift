//
//  VideoPreview.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation
import SwiftUI

@available(iOS 13.0, *)
struct VideoPreview: UIViewRepresentable {
    let captureSession: AVCaptureSession

    func makeUIView(context: UIViewRepresentableContext<VideoPreview>) -> AVCaptureVideoPreview {
        let view = AVCaptureVideoPreview()
        view.videoPreviewLayer.session = captureSession
        view.videoPreviewLayer.videoGravity = .resizeAspect
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        return view
    }

    func updateUIView(_ uiView: AVCaptureVideoPreview, context: UIViewRepresentableContext<VideoPreview>) {}
}
