//
//  MockCaptureProcessor.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

#if !os(tvOS)
import AVFoundation
import Foundation
@testable import MediaCore

@available(iOS 10, *)
final class MockCaptureProcessor: NSObject, CaptureProcessor {
    static var photoOutputDataToReturn: Data?
    static var livePhotoDataToReturn: LivePhotoData?

    weak var delegate: CaptureProcessorDelegate?

    @available(iOS 11, *)
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let data = Self.photoOutputDataToReturn {
            delegate?.didCapturePhoto(data: data)
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        if let data = Self.photoOutputDataToReturn {
            delegate?.didCapturePhoto(data: data)
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL,
                     duration: CMTime,
                     photoDisplayTime: CMTime,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     error: Error?) {
        if let data = Self.livePhotoDataToReturn {
            delegate?.didCaptureLivePhoto(data: data)
        }
    }
}
#endif
