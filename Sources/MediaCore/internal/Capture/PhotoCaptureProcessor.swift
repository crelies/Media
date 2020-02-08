//
//  PhotoCaptureProcessor.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

#if !os(tvOS)
import AVFoundation

@available(iOS 10, *)
@available(macOS, unavailable)
final class PhotoCaptureProcessor: NSObject, CaptureProcessor {
    private var stillImageData: Data?

    weak var delegate: CaptureProcessorDelegate?

    /*
        Image portion
     */
    @available(iOS 11, *)
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil else {
            stillImageData = nil
            return
        }

        guard let stillImageData = photo.fileDataRepresentation() else { return }

        self.stillImageData = stillImageData
        delegate?.didCapturePhoto(data: stillImageData)
    }

    #if !os(macOS)
    /*
       Image portion
    */
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        guard error == nil else {
            stillImageData = nil
            return
        }

        guard let photoSampleBuffer = photoSampleBuffer else { return }

        guard let stillImageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer,
                                                                                    previewPhotoSampleBuffer: previewPhotoSampleBuffer) else { return }

        self.stillImageData = stillImageData
        delegate?.didCapturePhoto(data: stillImageData)
    }

    /*
        Video portion
        Hint: fires later
     */
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL,
                     duration: CMTime,
                     photoDisplayTime: CMTime,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     error: Error?) {
        guard error == nil else {
            stillImageData = nil
            return
        }

        guard let stillImageData = stillImageData else { return }

        guard let movieURL = try? Media.URL<LivePhoto>(url: outputFileURL) else { return }

        let livePhotoData = LivePhotoData(stillImageData: stillImageData, movieURL: movieURL)
        delegate?.didCaptureLivePhoto(data: livePhotoData)
    }
    #endif
}
#endif
