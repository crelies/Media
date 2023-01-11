//
//  Photo+browser.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 04/09/2022.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import Combine
import MediaCore
import PhotosUI
import SwiftUI

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Photo {
    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected photos.
    ///
    /// - Returns: some View
    static func browser(
        isPresented: Binding<Bool>,
        selectionLimit: Int = 1,
        selection: Binding<[BrowserResult<Photo, UniversalImage>]>
    ) -> some View {
        browser(
            isPresented: isPresented,
            selectionLimit: selectionLimit,
            errorView: { error in Text(error.localizedDescription) },
            selection: selection
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter selection: A binding which represents the selected photos.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(isPresented: Binding<Bool>, selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, selection: Binding<[BrowserResult<Photo, UniversalImage>]>) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.filter = .images
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }(), selection: .init(get: {
                []
            }, set: { browserResult in
                if Media.currentPermission == .authorized {
                    let result = Result {
                        try browserResult.compactMap { object -> BrowserResult<Photo, UniversalImage>? in
                            guard let assetIdentifier = object.assetIdentifier else {
                                return nil
                            }
                            guard let photo = try Photo.with(identifier: .init(stringLiteral: assetIdentifier)) else {
                                return nil
                            }
                            return .media(photo, itemProvider: object.itemProvider)
                        }
                    }

                    switch result {
                    case let .success(results):
                        selection.wrappedValue = results
                    case let .failure(error):
                        // TODO: error handling
                        debugPrint(error)
                    }
                } else {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let loadImages = browserResult.map { $0.itemProvider.loadImage() }
                        Publishers.MergeMany(loadImages)
                            .collect()
                            .receive(on: DispatchQueue.main)
                            .sink { result in
                                switch result {
                                case let .failure(error):
                                    // TODO: error handling
                                    debugPrint(error)
                                case .finished: ()
                                }
                            } receiveValue: { urls in
                                let browserResults = urls.map { BrowserResult<Photo, UniversalImage>.data($0) }
                                selection.wrappedValue = browserResults
                            }
                            .store(in: &Garbage.cancellables)
                    }
                }
            }))
        } else {
            let result = Result {
                try ViewCreator.browser(mediaTypes: [.image]) { (result: Result<Photo, Swift.Error>) in
                    switch result {
                    case let .success(photo):
                        selection.wrappedValue = [.media(photo, itemProvider: nil)]
                    case let .failure(error):
                        // TODO: error handling
                        debugPrint(error)
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
