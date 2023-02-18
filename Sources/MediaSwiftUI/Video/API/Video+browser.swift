//
//  Video+browser.swift
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
public extension Video {
    /// Creates a ready-to-use `SwiftUI` view for browsing `Video`s in the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected videos.
    ///
    /// - Returns: some View
    static func browser(
        isPresented: Binding<Bool>,
        selectionLimit: Int = 1,
        selection: Binding<[BrowserResult<Video, URL>]>
    ) -> some View {
        browser(
            isPresented: isPresented,
            selectionLimit: selectionLimit,
            selection: selection,
            catchedError: nil
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing `Video`s in the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected videos.
    /// - Parameter catchedError: An optional write-only binding which represents a catched error.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser(
        isPresented: Binding<Bool>,
        selectionLimit: Int = 1,
        selection: Binding<[BrowserResult<Video, URL>]>,
        catchedError: Binding<Swift.Error?>? = nil
    ) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.filter = .videos
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }(), selection: .init(get: {
                // This is a write-only binding.
                []
            }, set: { result in
                if Media.currentPermission == .authorized {
                    let browserResult = Result {
                        try result.compactMap { object -> BrowserResult<Video, URL>? in
                            guard let assetIdentifier = object.assetIdentifier else {
                                return nil
                            }
                            guard let video = try Video.with(identifier: .init(stringLiteral: assetIdentifier)) else {
                                return nil
                            }
                            return .media(video, itemProvider: object.itemProvider)
                        }
                    }

                    switch browserResult {
                    case let .success(results):
                        selection.wrappedValue = results
                    case let .failure(error):
                        catchedError?.wrappedValue = error
                    }
                } else {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let loadVideos = result.map { $0.itemProvider.loadVideo() }
                        Publishers.MergeMany(loadVideos)
                            .collect()
                            .receive(on: DispatchQueue.main)
                            .sink { result in
                                switch result {
                                case let .failure(error):
                                    catchedError?.wrappedValue = error
                                case .finished: ()
                                }
                            } receiveValue: { urls in
                                let browserResults = urls.map { BrowserResult<Video, URL>.data($0) }
                                selection.wrappedValue = browserResults
                            }
                            .store(in: &Garbage.cancellables)
                    }
                }
            }))
        } else {
            ViewCreator.browser(
                mediaTypes: [.movie],
                selection: .writeOnly({(result: Result<Video, Swift.Error>?) in
                    switch result {
                    case let .success(video):
                        selection.wrappedValue = [.media(video, itemProvider: nil)]
                    case let .failure(error):
                        catchedError?.wrappedValue = error
                    case .none: ()
                    }
                })
            )
        }
    }
}
#endif

#endif
