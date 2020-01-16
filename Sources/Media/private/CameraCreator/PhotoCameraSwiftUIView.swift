//
//  PhotoCameraSwiftUIView.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import AVFoundation
import SwiftUI

@available(iOS 13.0, *)
struct PhotoCameraSwiftUIView: UIViewRepresentable {
    let captureSession: AVCaptureSession
    let output: AVCapturePhotoOutput
    let captureProcessor: AVCapturePhotoCaptureDelegate

    func makeUIView(context: UIViewRepresentableContext<PhotoCameraSwiftUIView>) -> PhotoCameraView {
        PhotoCameraView(captureSession: captureSession, output: output, captureProcessor: captureProcessor)
    }

    func updateUIView(_ uiView: PhotoCameraView, context: UIViewRepresentableContext<PhotoCameraSwiftUIView>) {}
}
