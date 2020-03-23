//
//  Video+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import SwiftUI

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Video {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    var view: some View {
        VideoView(video: self)
    }
}

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Video {
    /// Alias for a completion block getting a `Result` containing a `<Media.URL<Video>`
    /// on success or an `Error` on failure
    ///
    typealias ResultMediaURLVideoCompletion = (Result<Media.URL<Video>, Swift.Error>) -> Void

    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    ///
    /// - Parameter completion: a closure wich gets `Media.URL<Video>` on `success` or `Error` on `failure`
    ///
    static func camera(_ completion: @escaping ResultMediaURLVideoCompletion) throws -> some View {
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

    /// Creates a ready-to-use `SwiftUI` view for browsing `Video`s in the photo library
    ///
    /// - Parameter completion: a closure wich gets `Video` on `success` or `Error` on `failure`
    ///
    static func browser(_ completion: @escaping ResultVideoCompletion) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.movie], completion)
    }
}
#endif

#endif
