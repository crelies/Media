//
//  VideoPreview.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

#if canImport(UIKit) && !os(tvOS)
import AVFoundation
import SwiftUI
import UIKit

@available(iOS 13, *)
@available(macCatalyst 14, *)
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
#endif
