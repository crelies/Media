//
//  CameraViewCreator.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 16.01.20.
//

import AVFoundation
import MediaCore
import SwiftUI

struct CameraViewCreator {
    #if os(iOS)
    @available(iOS 13, *)
    @available(macCatalyst 14, *)
    static func livePhoto(
        cameraViewModel: PhotoCameraViewModel
    ) -> CustomPhotoCameraView {
        CustomPhotoCameraView(
            viewModel: cameraViewModel
        )
    }
    #endif

    #if !os(tvOS)
    @available(iOS 14, *)
    @available(macOS 11, *)
    @available(macCatalyst 14, *)
    static func video(
        viewModel: VideoCameraViewModel
    ) -> CustomVideoCameraView {
        CustomVideoCameraView(viewModel: viewModel)
    }
    #endif
}
