//
//  AVCaptureVideoPreview.swift
//  
//
//  Created by Christian Elies on 17.01.20.
//

import AVFoundation
import UIKit

@available(iOS 10, *)
final class AVCaptureVideoPreview: UIView {
    override static var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
