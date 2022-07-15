//
//  LivePhoto+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI)
import Combine
import MediaCore
import PhotosUI
import SwiftUI

#if !os(macOS) && !targetEnvironment(macCatalyst) && !os(tvOS)
@available(iOS 13, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view for capturing `LivePhoto`s
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter cameraViewModel: A view model handling all of the camera view logic.
    ///
    /// - Returns: some View
    static func camera(cameraViewModel: CameraViewModel) -> some View {
        camera(cameraViewModel: cameraViewModel, errorView: { error in Text(error.localizedDescription) })
    }

    /// Creates a ready-to-use `SwiftUI` view for capturing `LivePhoto`s
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter cameraViewModel: A view model handling all of the camera view logic.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    ///
    /// - Returns: some View
    @ViewBuilder static func camera<ErrorView: View>(cameraViewModel: CameraViewModel, @ViewBuilder errorView: (Swift.Error) -> ErrorView) -> some View {
        CameraViewCreator.livePhoto(cameraViewModel: cameraViewModel)
    }
}
#endif

#if !os(macOS) && !os(tvOS)
@available(iOS 13, macOS 10.15, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view for browsing `LivePhoto`s in the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter completion: A closure which gets the selected `LivePhoto` on `success` or `Error` on `failure`.
    ///
    /// - Returns: some View
    static func browser(isPresented: Binding<Bool>, selectionLimit: Int = 1, _ completion: @escaping ResultLivePhotosCompletion) -> some View {
        browser(isPresented: isPresented, selectionLimit: selectionLimit, errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing `LivePhoto`s in the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure which gets the selected `LivePhoto` on `success` or `Error` on `failure`.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(isPresented: Binding<Bool>, selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultLivePhotosCompletion) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.filter = .livePhotos
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }()) { result in
                switch result {
                case let .success(result):
                    if Media.currentPermission == .authorized {
                        let result = Result {
                            try result.compactMap { object -> BrowserResult<LivePhoto, PHLivePhoto>? in
                                guard let assetIdentifier = object.assetIdentifier else {
                                    return nil
                                }
                                guard let livePhoto = try LivePhoto.with(identifier: .init(stringLiteral: assetIdentifier)) else {
                                    return nil
                                }
                                return .media(livePhoto)
                            }
                        }
                        completion(result)
                    } else {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let loadLivePhotos = result.map { $0.itemProvider.loadLivePhoto() }
                            Publishers.MergeMany(loadLivePhotos)
                                .collect()
                                .receive(on: DispatchQueue.main)
                                .sink { result in
                                    switch result {
                                    case let .failure(error):
                                        completion(.failure(error))
                                    case .finished: ()
                                    }
                                } receiveValue: { urls in
                                    let browserResults = urls.map { BrowserResult<LivePhoto, PHLivePhoto>.data($0) }
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
                try ViewCreator.browser(mediaTypes: [.image, .livePhoto]) { (result: Result<LivePhoto, Error>) in
                    switch result {
                    case let .success(livePhoto):
                        completion(.success([.media(livePhoto)]))
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

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 13, tvOS 13, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    /// - Parameter size: the desired size of the `LivePhoto`
    ///
    func view(size: CGSize) -> some View {
        LivePhotoView(livePhoto: self, size: size)
    }
}
#endif

#endif
