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
public final class Photograph: NSObject {
    static var captureProcessor: CaptureProcessor.Type = PhotoCaptureProcessor.self

    private let photoOutput: AVCapturePhotoOutput
    private let photoSettings: AVCapturePhotoSettings
    private var captureProcessor: CaptureProcessor?
    private var stillImageCompletion: ResultDataCompletion?
    private var livePhotoCompletion: LivePhotoDataCompletion?

    public init(photoOutput: AVCapturePhotoOutput, photoSettings: AVCapturePhotoSettings) {
        self.photoOutput = photoOutput
        self.photoSettings = photoSettings
    }
}

@available(iOS 10, *)
@available(macOS, unavailable)
public extension Photograph {
    func shootPhoto(stillImageCompletion: @escaping ResultDataCompletion,
                    livePhotoCompletion: LivePhotoDataCompletion?) {
        self.stillImageCompletion = stillImageCompletion
        self.livePhotoCompletion = livePhotoCompletion

        let captureProcessor = Self.captureProcessor.init()
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
