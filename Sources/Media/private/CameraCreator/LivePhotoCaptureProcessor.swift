//
//  LivePhotoCaptureProcessor.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import AVFoundation

final class LivePhotoCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    private var stillImageData: Data?
    private let completion: (Result<(Data, URL), Error>) -> Void

    init(_ completion: @escaping (Result<(Data, URL), Swift.Error>) -> Void) {
        self.completion = completion
    }

    /*
        Image portion of live photo
     */
    @available(iOS 11, *)
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil else {
            stillImageData = nil
            completion(.failure(error ?? MediaError.unknown))
            return
        }

        stillImageData = photo.fileDataRepresentation()
    }

    /*
        Video portion of live photo
        Hint: fires later
     */
    @available(iOS 10, *)
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL,
                     duration: CMTime,
                     photoDisplayTime: CMTime,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     error: Error?) {
        guard error == nil else {
            stillImageData = nil
            completion(.failure(error ?? MediaError.unknown))
            return
        }

        guard let stillImageData = stillImageData else { return }

        completion(.success((stillImageData, outputFileURL)))
    }
}
