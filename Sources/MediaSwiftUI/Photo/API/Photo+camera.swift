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
    typealias ResultPhotoCameraResultCompletion = (Result<Camera.Result, Swift.Error>) -> Void

    /// Creates a ready-to-use `SwiftUI` view for capturing `Photo`s
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter completion: A closure which gets a `Result` (`Photo.Camera.Result` on `success` or `Error` on `failure`).
    ///
    /// - Returns: some View
    static func camera(_ completion: @escaping ResultPhotoCameraResultCompletion) -> some View {
        camera(errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `Photo`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure which gets a `Result` (`Photo.Camera.Result` on `success` or `Error` on `failure`).
    ///
    /// - Returns: some View
    @ViewBuilder static func camera<ErrorView: View>(@ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultPhotoCameraResultCompletion) -> some View {
        let result = Result {
            try ViewCreator.camera(for: [.image]) { result in
                switch result {
                case .success(let cameraResult):
                    switch cameraResult {
                    case .tookPhoto(let image):
                        completion(.success(.tookPhoto(image: image)))
                    default:
                        completion(.failure(Photo.Error.unsupportedCameraResult))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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

#endif
