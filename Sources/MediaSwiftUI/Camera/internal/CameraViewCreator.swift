//
//  CameraViewCreator.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 16.01.20.
//

#if os(iOS)
import AVFoundation
import MediaCore
import SwiftUI

@available(iOS 13, *)
struct CameraViewCreator {
    @available(macCatalyst 14, *)
    static func livePhoto(
        cameraViewModel: PhotoCameraViewModel
    ) -> CustomPhotoCameraView {
        CustomPhotoCameraView(
            viewModel: cameraViewModel
        )
    }
}
#endif