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
            Task {
                do {
                    let livePhoto = try await LivePhoto.save(data: capturedPhotoData)
                    debugPrint("Live photo identifier: \(livePhoto.identifier)")
                } catch {
                    debugPrint("Live photo save error: \(error)")
                }
            }
            #endif
        }

        let rootCameraViewModel: PhotoCameraViewModel = try! PhotoCameraViewModel.make(
            selection: livePhotoCaptureBinding
        )
        self.photoCameraViewModel = rootCameraViewModel

        var videoURLResult: Result<Media.URL<Video>, Error>?
        let videoCaptureBinding: Binding<Result<Media.URL<Video>, Error>?> = .init(
            get: { videoURLResult },
            set: { videoURLResult = $0 }
        ).onChange { result in
            guard let mediaURL = try? result?.get() else {
                return
            }

            Task {
                do {
                    /// **Attention:** This is working but will not automatically upload the video to the iCloud. You have to open the photos app on your mac first.
                    let video = try await Video.save(mediaURL)
                    debugPrint("Video identifier: \(video.identifier)")
                } catch {
                    debugPrint("Video save error: \(error)")
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
