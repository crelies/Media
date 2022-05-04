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
@available(macCatalyst 14, *)
/// Service for shooting (live) photos
/// using `AVCapture` APIs
///
public final class Photograph: NSObject {
    static var captureProcessor: CaptureProcessor.Type = PhotoCaptureProcessor.self

    private let photoOutput: AVCapturePhotoOutput
    private let photoSettings: AVCapturePhotoSettings
    private var captureProcessor: CaptureProcessor?
    private var stillImageCompletion: ResultDataCompletion?
    private var livePhotoCompletion: LivePhotoDataCompletion?

    /// Initializes a photograph
    ///
    /// - Parameters:
    ///   - photoOutput: the photo output to use for capturing
    ///   - photoSettings: the photo settings to use for capturing
    ///
    public init(photoOutput: AVCapturePhotoOutput, photoSettings: AVCapturePhotoSettings) {
        self.photoOutput = photoOutput
        self.photoSettings = photoSettings
    }
}

@available(iOS 10, *)
@available(macOS, unavailable)
@available(macCatalyst 14, *)
public extension Photograph {
    /// Tells the receiver to shoot a photo
    ///
    /// - Parameters:
    ///   - stillImageCompletion: block which should be called if a still image was taken
    ///   - livePhotoCompletion: block which should be called if a live photo was taken
    ///
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
@available(macCatalyst 14, *)
extension Photograph: CaptureProcessorDelegate {
    func didCapturePhoto(data: Data) {
        stillImageCompletion?(.success(data))
    }

    func didCaptureLivePhoto(data: LivePhotoData) {
        livePhotoCompletion?(.success(data))
    }
}
#endif
