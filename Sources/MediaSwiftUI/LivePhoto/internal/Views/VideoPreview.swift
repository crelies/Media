//
//  VideoPreview.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation
import SwiftUI

#if canImport(UIKit) && !os(tvOS)
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
#elseif os(macOS)
import AppKit

struct VideoPreview: NSViewRepresentable {
    let captureSession: AVCaptureSession

    func makeNSView(context: NSViewRepresentableContext<VideoPreview>) -> AVCaptureVideoPreview {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        return AVCaptureVideoPreview(layer: videoPreviewLayer)
    }

    func updateNSView(_ nsView: AVCaptureVideoPreview, context: NSViewRepresentableContext<VideoPreview>) {}
}
#endif
