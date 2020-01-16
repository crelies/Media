//
//  PhotoCameraView.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import AVFoundation
import SwiftUI

@available(iOS 10, *)
final class PhotoCameraView: UIView {
    private let output: AVCapturePhotoOutput
    private weak var captureProcessor: AVCapturePhotoCaptureDelegate?

    private lazy var captureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Capture", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(capture(_:)), for: .touchUpInside)
        return button
    }()

    override static var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    init(captureSession: AVCaptureSession, output: AVCapturePhotoOutput, captureProcessor: AVCapturePhotoCaptureDelegate?) {
        self.output = output
        self.captureProcessor = captureProcessor
        super.init(frame: .infinite)
        videoPreviewLayer.session = captureSession

        addSubview(captureButton)

        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(session:output:) instead")
    }
}

@available(iOS 10, *)
extension PhotoCameraView {
    @objc private func capture(_ sender: UIButton) {
        guard let captureProcessor = captureProcessor else { return }

        var photoSettings: AVCapturePhotoSettings

        if #available(iOS 11.0, *) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecH264])
        }

        let userDocumentsDirectory = FileManager.default.userDocumentsDirectory
        photoSettings.livePhotoMovieFileURL = userDocumentsDirectory.appendingPathComponent("\(UUID().uuidString).mov")
        output.capturePhoto(with: photoSettings, delegate: captureProcessor)
    }
}
