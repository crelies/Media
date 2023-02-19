//
//  Video+camera.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 04/09/2022.
//

#if canImport(SwiftUI)
import MediaCore
import SwiftUI

#if !os(tvOS) && !os(macOS)
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
            selection: selection,
            catchedError: nil
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter catchedError: An optional write-only binding which represents a catched error.
    ///
    /// - Returns: some View
    @ViewBuilder static func camera(
        selection: Binding<Media.URL<Video>?>,
        catchedError: Binding<Swift.Error?>? = nil
    ) -> some View {
        ViewCreator.camera(
            for: [.movie],
            selection: .writeOnly({ result in
                switch result {
                case .success(let cameraResult):
                    switch cameraResult {
                    case .tookVideo(let url):
                        do {
                            let mediaURL = try Media.URL<Video>(url: url)
                            selection.wrappedValue = mediaURL
                        } catch {
                            catchedError?.wrappedValue = error
                        }
                    default:
                        // This should never happen
                        assertionFailure(Video.Error.unsupportedCameraResult.localizedDescription)
                    }
                case .failure(let error):
                    catchedError?.wrappedValue = error
                case .none: ()
                }
            })
        )
    }
}
#elseif os(macOS)
@available(macOS 11, *)
public extension Video {
    /// <#Description#>
    ///
    /// - Parameter viewModel: <#viewModel description#>
    ///
    /// - Returns: <#description#>
    static func camera(
        viewModel: VideoCameraViewModel
    ) -> some View {
        CustomVideoCameraView(viewModel: viewModel)
    }
}
#endif

#endif
