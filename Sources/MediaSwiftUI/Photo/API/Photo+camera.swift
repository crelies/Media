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
    @ViewBuilder
    static func camera(selection: Binding<Camera.Result?>) -> some View {
        camera(selection: selection, catchedError: nil)
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `Photo`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter selection: A binding which represents the captured photo.
    /// - Parameter catchedError: An optional write-only binding which represents a catched error.
    ///
    /// - Returns: some View
    static func camera(
        selection: Binding<Camera.Result?>,
        catchedError: Binding<Swift.Error?>? = nil
    ) -> some View {
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
                    catchedError?.wrappedValue = error
                case .none: ()
                }
            })
        )
    }
}
#endif

#endif
