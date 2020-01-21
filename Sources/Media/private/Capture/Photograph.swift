//
//  Photograph.swift
//  
//
//  Created by Christian Elies on 18.01.20.
//

#if !os(tvOS)
import AVFoundation

@available(iOS 10, *)
@available(macOS, unavailable)
final class Photograph: NSObject {
    private let photoOutput: AVCapturePhotoOutput
    private let photoSettings: AVCapturePhotoSettings
    private var captureProcessor: CaptureProcessor?
    private var stillImageCompletion: ((Result<Data, Error>) -> Void)?
    private var livePhotoCompletion: ((Result<LivePhotoData, Error>) -> Void)?

    init(photoOutput: AVCapturePhotoOutput, photoSettings: AVCapturePhotoSettings) {
        self.photoOutput = photoOutput
        self.photoSettings = photoSettings
    }
}

@available(iOS 10, *)
@available(macOS, unavailable)
extension Photograph {
    func shootPhoto(stillImageCompletion: @escaping (Result<Data, Error>) -> Void,
                    livePhotoCompletion: ((Result<LivePhotoData, Error>) -> Void)?) {
        self.stillImageCompletion = stillImageCompletion
        self.livePhotoCompletion = livePhotoCompletion

        let captureProcessor = PhotoCaptureProcessor()
        captureProcessor.delegate = self
        self.captureProcessor = captureProcessor

        photoOutput.capturePhoto(with: AVCapturePhotoSettings(from: photoSettings), delegate: captureProcessor)
    }
}

@available(iOS 10, *)
@available(macOS, unavailable)
extension Photograph: CaptureProcessorDelegate {
    func didCapturePhoto(data: Data) {
        stillImageCompletion?(.success(data))
    }

    func didCaptureLivePhoto(data: LivePhotoData) {
        livePhotoCompletion?(.success(data))
    }
}
#endif
