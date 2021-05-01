//
//  Camera.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import MediaCore
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
/// Type which provides a ready-to-use SwiftUI view
///
public struct Camera {
    public typealias ResultCameraResultCompletion = (Swift.Result<Camera.Result, Swift.Error>) -> Void

    /// A ready-to-use `SwiftUI` camera view which returns the URL to the
    /// captured media on `success`
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter completion: A closure which gets the `Result` (`CameraResult` on `success` or `Error` on `failure`).
    ///
    /// - Returns: some View
    public static func view(_ completion: @escaping ResultCameraResultCompletion) -> some View {
        view(errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// A ready-to-use `SwiftUI` camera view which returns the URL to the
    /// captured media on `success`
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure which gets the `Result` (`CameraResult` on `success` or `Error` on `failure`).
    ///
    /// - Returns: some View
    @ViewBuilder public static func view<ErrorView: View>(@ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultCameraResultCompletion) -> some View {
        let result = Swift.Result<MediaPicker, Swift.Error> {
            let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
            let mediaTypes = try availableMediaTypes.map { try UIImagePickerController.MediaType(string: $0) }
            return try ViewCreator.camera(for: Set(mediaTypes), completion)
        }
        switch result {
        case let .success(view):
            view
        case let .failure(error):
            errorView(error)
        }
    }
}
#endif
