//
//  MockAVCapturePhotoOutput.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

import AVFoundation

@available(iOS 11, *)
final class MockAVCapturePhotoOutput: AVCapturePhotoOutput {
    var livePhotoMovieURLToReturn: URL?

    override func capturePhoto(with settings: AVCapturePhotoSettings, delegate: AVCapturePhotoCaptureDelegate) {
        let resolvedSettings = MockAVCaptureResolvedPhotoSettings()
        let avCapturePhoto = MockAVCapturePhoto()

        delegate.photoOutput?(self, didFinishProcessingPhoto: avCapturePhoto, error: nil)

        if let livePhotoMovieURLToReturn = livePhotoMovieURLToReturn {
            delegate.photoOutput?(self,
                                  didFinishProcessingLivePhotoToMovieFileAt: livePhotoMovieURLToReturn,
                                  duration: .init(seconds: 60, preferredTimescale: .max),
                                  photoDisplayTime: .init(seconds: 5, preferredTimescale: .max),
                                  resolvedSettings: resolvedSettings,
                                  error: nil)
        }
    }
}
