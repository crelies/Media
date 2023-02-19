//
//  AVCaptureVideoPreview.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation

#if canImport(UIKit)
import UIKit

@available(iOS 10, *)
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
#elseif os(macOS)
import AppKit

final class AVCaptureVideoPreview: NSView {
    init(layer: AVCaptureVideoPreviewLayer) {
        super.init(frame: .zero)
        self.layer = layer
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
#endif
