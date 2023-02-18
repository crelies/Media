//
//  Photo+camera.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 04/09/2022.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import SwiftUI

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Photo {
    /// Creates a ready-to-use `SwiftUI` view for capturing `Photo`s
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter selection: A binding which represents the captured photo.
    ///
    /// - Returns: some View
    static func camera(selection: Binding<Camera.Result?>) -> some View {
        camera(
            errorView: { error in Text(error.localizedDescription) },
            selection: selection
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `Photo`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter selection: A binding which represents the captured photo.
    ///
    /// - Returns: some View
    @ViewBuilder static func camera<ErrorView: View>(@ViewBuilder errorView: (Swift.Error) -> ErrorView, selection: Binding<Camera.Result?>) -> some View {
        ViewCreator.camera(
            for: [.image],
            selection: .writeOnly({ result in
                switch result {
                case .success(let cameraResult):
                    switch cameraResult {
                    case .tookPhoto(let image):
                        selection.wrappedValue = .tookPhoto(image: image)
                    default:
                        // This should never happen.
                        assertionFailure(Photo.Error.unsupportedCameraResult.localizedDescription)
                    }
                case .failure(let error):
                    // TODO: error handling (use error view)
                    debugPrint(error)
                case .none: ()
                }
            })
        )
    }
}
#endif

#endif
