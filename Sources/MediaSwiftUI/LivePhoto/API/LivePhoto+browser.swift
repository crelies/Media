//
//  LivePhoto+browser.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03/09/2022.
//

#if canImport(SwiftUI)
import Combine
import MediaCore
import PhotosUI
import SwiftUI

#if !os(macOS) && !os(tvOS)
@available(iOS 13, macOS 10.15, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view for browsing `LivePhoto`s in the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected live photos.
    ///
    /// - Returns: some View
    static func browser(isPresented: Binding<Bool>, selectionLimit: Int = 1, selection: Binding<[BrowserResult<LivePhoto, PHLivePhoto>]>) -> some View {
        browser(
            isPresented: isPresented,
            selectionLimit: selectionLimit,
            errorView: { error in Text(error.localizedDescription) },
            selection: selection
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing `LivePhoto`s in the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter selection: A binding which represents the selected live photos.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(isPresented: Binding<Bool>, selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, selection: Binding<[BrowserResult<LivePhoto, PHLivePhoto>]>) -> some View {
        // TODO: iOS 16 version
//        if #available(iOS 16, macOS 13, *) {
//            PhotosPicker(selection: <#T##Binding<[PhotosPickerItem]>#>, selectionBehavior: .ordered, maxSelectionCount: selectionLimit, photoLibrary: .shared()) {
//                Text("Picker")
//            }
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.filter = .livePhotos
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }(), selection: .init(get: {
                []
            }, set: { browserResult in
                if Media.currentPermission == .authorized {
                    let result = Result {
                        try browserResult.compactMap { object -> BrowserResult<LivePhoto, PHLivePhoto>? in
                            guard let assetIdentifier = object.assetIdentifier else {
                                return nil
                            }
                            guard let livePhoto = try LivePhoto.with(identifier: .init(stringLiteral: assetIdentifier)) else {
                                return nil
                            }
                            return .media(livePhoto, itemProvider: object.itemProvider)
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
                        let loadLivePhotos = browserResult.map { $0.itemProvider.loadLivePhoto() }
                        Publishers.MergeMany(loadLivePhotos)
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
                                let browserResults = urls.map { BrowserResult<LivePhoto, PHLivePhoto>.data($0) }
                                selection.wrappedValue = browserResults
                            }
                            .store(in: &Garbage.cancellables)
                    }
                }
            }))
        } else {
            ViewCreator.browser(mediaTypes: [.image, .livePhoto]) { (result: Result<LivePhoto, Error>) in
                switch result {
                case let .success(livePhoto):
                    selection.wrappedValue = [.media(livePhoto, itemProvider: nil)]
                case let .failure(error):
                    // TODO: error handling (use error view)
                    debugPrint(error)
                }
            }
        }
    }
}
#endif

#endif
