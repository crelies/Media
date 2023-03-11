//
//  Dependencies.swift
//  Media-Example
//
//  Created by Christian Elies on 20/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import MediaCore
import MediaSwiftUI
import SwiftUI

struct Dependencies {
    #if !os(tvOS)
    let photoCameraViewModel: PhotoCameraViewModel
    let videoCameraViewModel: VideoCameraViewModel
    #endif

    init() {
        #if !os(tvOS)
        var livePhotoCaptureResult: Result<CapturedPhotoData, Error>?
        
        let livePhotoCaptureBinding: Binding<Result<CapturedPhotoData, Error>?> = .init(
            get: { livePhotoCaptureResult },
            set: { livePhotoCaptureResult = $0 }
        ).onChange { result in
            guard let capturedPhotoData: CapturedPhotoData = try? result?.get() else {
                return
            }

            #if !targetEnvironment(macCatalyst) && !os(macOS)
            try? LivePhoto.save(data: capturedPhotoData) { result in
                switch result {
                case .failure(let error):
                    debugPrint("Live photo save error: \(error)")
                default: ()
                }
            }
            #endif
        }

        let rootCameraViewModel: PhotoCameraViewModel = try! PhotoCameraViewModel.make(
            selection: livePhotoCaptureBinding
        )
        self.photoCameraViewModel = rootCameraViewModel

        var videoURLResult: Result<URL, Error>?
        let videoCaptureBinding: Binding<Result<URL, Error>?> = .init(
            get: { videoURLResult },
            set: { videoURLResult = $0 }
        ).onChange { result in
            guard let videoURL: URL = try? result?.get() else {
                return
            }

            guard let mediaURL = try? Media.URL<Video>(url: videoURL) else {
                assertionFailure("This should not happen")
                return
            }

            // TODO: this is currently not working
            Video.save(mediaURL) { result in
                switch result {
                case .failure(let error):
                    debugPrint("Video save error: \(error)")
                default: ()
                }
            }
        }

        let rootVideoCameraViewModel: VideoCameraViewModel = try! VideoCameraViewModel.make(
            selection: videoCaptureBinding
        )
        self.videoCameraViewModel = rootVideoCameraViewModel
        #endif
    }
}
