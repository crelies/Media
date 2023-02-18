//
//  Video+camera.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 04/09/2022.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import SwiftUI

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Video {
    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter selection: A binding which represents the recorded video.
    ///
    /// - Returns: some View
    static func camera(selection: Binding<Media.URL<Video>?>) -> some View {
        camera(
            errorView: { error in Text(error.localizedDescription) },
            selection: selection
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter selection: A binding which represents the recorded video.
    ///
    /// - Returns: some View
    @ViewBuilder static func camera<ErrorView: View>(@ViewBuilder errorView: (Swift.Error) -> ErrorView, selection: Binding<Media.URL<Video>?>) -> some View {
        ViewCreator.camera(for: [.movie]) { result in
            switch result {
            case .success(let cameraResult):
                switch cameraResult {
                case .tookVideo(let url):
                    do {
                        let mediaURL = try Media.URL<Video>(url: url)
                        selection.wrappedValue = mediaURL
                    } catch {
                        // TODO: error handling (use error view)
                        debugPrint(error)
                    }
                default:
                    // TODO: error handling (use error view)
                    debugPrint(Video.Error.unsupportedCameraResult)
                }
            case .failure(let error):
                // TODO: error handling (use error view)
                debugPrint(error)
            }
        }
    }
}
#endif

#endif
