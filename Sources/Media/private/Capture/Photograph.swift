//
//  Photograph.swift
//  
//
//  Created by Christian Elies on 18.01.20.
//

import AVFoundation

@available(iOS 10.0, *)
final class Photograph: NSObject {
    private let output: AVCapturePhotoOutput
    private let settings: AVCapturePhotoSettings
    private var captureProcessor: CaptureProcessor?
    private var stillImageCompletion: ((Result<Data, Error>) -> Void)?
    private var livePhotoCompletion: ((Result<LivePhotoData, Error>) -> Void)?

    init(output: AVCapturePhotoOutput, settings: AVCapturePhotoSettings) {
        self.output = output
        self.settings = settings
    }
}

@available(iOS 10.0, *)
extension Photograph {
    func captureLivePhoto(stillImageCompletion: @escaping (Result<Data, Error>) -> Void,
                          livePhotoCompletion: @escaping (Result<LivePhotoData, Error>) -> Void) {
        self.stillImageCompletion = stillImageCompletion
        self.livePhotoCompletion = livePhotoCompletion

        let captureProcessor = PhotoCaptureProcessor()
        captureProcessor.delegate = self
        self.captureProcessor = captureProcessor

        output.capturePhoto(with: AVCapturePhotoSettings(from: settings), delegate: captureProcessor)
    }
}

@available(iOS 10.0, *)
extension Photograph: CaptureProcessorDelegate {
    func didCapturePhoto(data: Data) {
        stillImageCompletion?(.success(data))
    }

    func didCaptureLivePhoto(data: LivePhotoData) {
        livePhotoCompletion?(.success(data))
    }
}
