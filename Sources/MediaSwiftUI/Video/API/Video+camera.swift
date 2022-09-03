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
    /// Alias for a completion block getting a `Result` containing a `<Media.URL<Video>`
    /// on success or an `Error` on failure
    ///
    typealias ResultMediaURLVideoCompletion = (Result<Media.URL<Video>, Swift.Error>) -> Void

    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter completion: A closure wich gets `Media.URL<Video>` on `success` or `Error` on `failure`.
    ///
    /// - Returns: some View
    static func camera(_ completion: @escaping ResultMediaURLVideoCompletion) -> some View {
        camera(errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure wich gets `Media.URL<Video>` on `success` or `Error` on `failure`.
    ///
    /// - Returns: some View
    @ViewBuilder static func camera<ErrorView: View>(@ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultMediaURLVideoCompletion) -> some View {
        let result = Result {
            try ViewCreator.camera(for: [.movie]) { result in
                switch result {
                case .success(let cameraResult):
                    switch cameraResult {
                    case .tookVideo(let url):
                        do {
                            let mediaURL = try Media.URL<Video>(url: url)
                            completion(.success(mediaURL))
                        } catch {
                            completion(.failure(error))
                        }
                    default:
                        completion(.failure(Video.Error.unsupportedCameraResult))
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
