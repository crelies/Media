//
//  LivePhoto+camera.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03/09/2022.
//

#if canImport(SwiftUI)
import MediaCore
import SwiftUI

#if !os(macOS) && !targetEnvironment(macCatalyst) && !os(tvOS)
@available(iOS 13, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view for capturing `LivePhoto`s
    ///
    /// - Parameter cameraViewModel: A view model handling all of the camera view logic.
    ///
    /// - Returns: some View
    static func camera(
        cameraViewModel: PhotoCameraViewModel
    ) -> some View {
        CameraViewCreator.livePhoto(cameraViewModel: cameraViewModel)
    }
}
#endif

#endif
