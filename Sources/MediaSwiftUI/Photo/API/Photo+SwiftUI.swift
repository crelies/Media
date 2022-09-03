//
//  Photo+SwiftUI.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import Combine
import MediaCore
import Photos
import PhotosUI
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

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter completion: A closure which gets a `Result` (`Photo` on `success` or `Error` on `failure`).
    ///
    /// - Returns: some View
    static func browser(isPresented: Binding<Bool>, selectionLimit: Int = 1, _ completion: @escaping ResultPhotosCompletion) -> some View {
        browser(isPresented: isPresented, selectionLimit: selectionLimit, errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure which gets a `Result` (`Photo` on `success` or `Error` on `failure`).
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(isPresented: Binding<Bool>, selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultPhotosCompletion) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.filter = .images
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }()) { result in
                switch result {
                case let .success(result):
                    if Media.currentPermission == .authorized {
                        let result = Result {
                            try result.compactMap { object -> BrowserResult<Photo, UniversalImage>? in
                                guard let assetIdentifier = object.assetIdentifier else {
                                    return nil
                                }
                                guard let photo = try Photo.with(identifier: .init(stringLiteral: assetIdentifier)) else {
                                    return nil
                                }
                                return .media(photo, itemProvider: object.itemProvider)
                            }
                        }
                        completion(result)
                    } else {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let loadImages = result.map { $0.itemProvider.loadImage() }
                            Publishers.MergeMany(loadImages)
                                .collect()
                                .receive(on: DispatchQueue.main)
                                .sink { result in
                                    switch result {
                                    case let .failure(error):
                                        completion(.failure(error))
                                    case .finished: ()
                                    }
                                } receiveValue: { urls in
                                    let browserResults = urls.map { BrowserResult<Photo, UniversalImage>.data($0) }
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
                try ViewCreator.browser(mediaTypes: [.image]) { (result: Result<Photo, Swift.Error>) in
                    switch result {
                    case let .success(photo):
                        completion(.success([.media(photo, itemProvider: nil)]))
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

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Photo {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    /// - Parameter targetSize: specifies the desired size of the photo (width and height), defaults to `nil`.
    /// - Parameter contentMode: specifies the desired content mode of the photo, defaults to `.aspectFit`.
    /// - Parameter imageView: a post processing closure which gets the `SwiftUI` `Image` view for further modification, like applying modifiers.
    ///
    /// - Returns: some `View`
    func view<ImageView: View>(targetSize: CGSize? = nil, contentMode: PHImageContentMode = .aspectFit, @ViewBuilder imageView: @escaping (Image) -> ImageView) -> some View {
        PhotoView(photo: self, targetSize: targetSize, contentMode: contentMode, imageView: imageView)
    }
}

#endif
