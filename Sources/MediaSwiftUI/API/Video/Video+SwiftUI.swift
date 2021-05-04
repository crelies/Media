//
//  Video+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import Combine
import MediaCore
import PhotosUI
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

    /// Creates a ready-to-use `SwiftUI` view for browsing `Video`s in the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter completion: A closure wich gets `Video` on `success` or `Error` on `failure`.
    ///
    /// - Returns: some View
    static func browser(isPresented: Binding<Bool>, selectionLimit: Int = 1, _ completion: @escaping ResultVideosCompletion) -> some View {
        browser(isPresented: isPresented, selectionLimit: selectionLimit, errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing `Video`s in the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure wich gets `Video` on `success` or `Error` on `failure`.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(isPresented: Binding<Bool>, selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultVideosCompletion) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.filter = .videos
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }()) { result in
                switch result {
                case let .success(result):
                    if Media.currentPermission == .authorized {
                        let browserResult = Result {
                            try result.compactMap { object -> BrowserResult<Video, URL>? in
                                guard let assetIdentifier = object.assetIdentifier else {
                                    return nil
                                }
                                guard let video = try Video.with(identifier: .init(stringLiteral: assetIdentifier)) else {
                                    return nil
                                }
                                return .media(video)
                            }
                        }
                        completion(browserResult)
                    } else {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let loadVideos = result.map { $0.itemProvider.loadVideo() }
                            Publishers.MergeMany(loadVideos)
                                .collect()
                                .receive(on: DispatchQueue.main)
                                .sink { result in
                                    switch result {
                                    case let .failure(error):
                                        completion(.failure(error))
                                    case .finished: ()
                                    }
                                } receiveValue: { urls in
                                    let browserResults = urls.map { BrowserResult<Video, URL>.data($0) }
                                    completion(.success(browserResults))
                                }
                                .store(in: &Garbage.cancellables)
                        }
                    }
                case let .failure(error): ()
                    completion(.failure(error))
                }
            }
        } else {
            let result = Result {
                try ViewCreator.browser(mediaTypes: [.movie]) { (result: Result<Video, Swift.Error>) in
                    switch result {
                    case let .success(video):
                        completion(.success([.media(video)]))
                    case let .failure(error):
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
}
#endif

#endif
