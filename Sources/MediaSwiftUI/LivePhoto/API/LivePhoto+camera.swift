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
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter cameraViewModel: A view model handling all of the camera view logic.
    ///
    /// - Returns: some View
    static func camera(cameraViewModel: LivePhotoCameraViewModel) -> some View {
        camera(cameraViewModel: cameraViewModel, errorView: { error in Text(error.localizedDescription) })
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `LivePhoto`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter cameraViewModel: A view model handling all of the camera view logic.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    ///
    /// - Returns: some View
    @ViewBuilder static func camera<ErrorView: View>(cameraViewModel: LivePhotoCameraViewModel, @ViewBuilder errorView: (Swift.Error) -> ErrorView) -> some View {
        CameraViewCreator.livePhoto(cameraViewModel: cameraViewModel)
    }
}
#endif

#endif
