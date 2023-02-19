//
//  AVCaptureVideoPreview.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 17.01.20.
//

#if canImport(UIKit)
import AVFoundation
import UIKit

@available(iOS 10, *)
@available(macOS 10.15, *)
@available(macCatalyst 14, *)
@available(tvOS, unavailable)
final class AVCaptureVideoPreview: UIView {
    override static var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
#endif
