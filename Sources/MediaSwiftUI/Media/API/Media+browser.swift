//
//  Media+SwiftUI.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import MediaCore
import Photos
import PhotosUI
import SwiftUI

@available(iOS 13, macCatalyst 13, *)
public extension Media {
    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected assets.
    ///
    /// - Returns: some View
    @available(iOS, deprecated: 16.0, message: "Use PhotosPicker")
    @available(macCatalyst, deprecated: 16.0, message: "Use PhotosPicker")
    static func browser(
        isPresented: Binding<Bool>,
        selectionLimit: Int = 1,
        selection: Binding<[BrowserResult<PHAsset, NSItemProvider>]>
    ) -> some View {
        browser(
            isPresented: isPresented,
            selectionLimit: selectionLimit,
            selection: selection,
            catchedError: nil
        )
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected assets.
    /// - Parameter catchedError: An optional write-only binding which represents a catched error.
    ///
    /// - Returns: some View
    @available(iOS, deprecated: 16.0, message: "Use PhotosPicker instead")
    @available(macCatalyst, deprecated: 16.0, message: "Use PhotosPicker instead")
    @ViewBuilder static func browser(
        isPresented: Binding<Bool
        >, selectionLimit: Int = 1,
        selection: Binding<[BrowserResult<PHAsset, NSItemProvider>]>,
        catchedError: Binding<Swift.Error?>? = nil
    ) -> some View {
        if #available(iOS 14, macCatalyst 14, *) {
            PHPicker(
                isPresented: isPresented,
                configuration: {
                    var configuration = PHPickerConfiguration(photoLibrary: .shared())
                    configuration.selectionLimit = selectionLimit
                    configuration.preferredAssetRepresentationMode = .current
                    return configuration
                }(),
                selection: .init(
                    get: {
                        // Value is never read
                        []
                    },
                    set: { browserResult in
                        if Media.currentPermission == .authorized {
                            let identifiers = browserResult.compactMap { $0.assetIdentifier }
                            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                            var assets: [PHAsset] = []
                            fetchResult.enumerateObjects { asset, _, _ in
                                assets.append(asset)
                            }
                            let browserResults = assets.map { BrowserResult<PHAsset, NSItemProvider>.media($0, itemProvider: nil) }
                            selection.wrappedValue = browserResults
                        } else {
                            let browserResults = browserResult.map { BrowserResult<PHAsset, NSItemProvider>.data($0.itemProvider) }
                            selection.wrappedValue = browserResults
                        }
                    }
                )
            )
        } else {
            if let sourceType = UIImagePickerController.availableSourceType {
                MediaPicker(
                    sourceType: sourceType,
                    mediaTypes: [],
                    selection: .writeOnly({ result in
                        switch result {
                        case let .success(value):
                            guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                                // This should never happen
                                assertionFailure(MediaPicker.Error.unsupportedValue.localizedDescription)
                                return
                            }
                            selection.wrappedValue = [.media(phAsset, itemProvider: nil)]
                        case let .failure(error):
                            catchedError?.wrappedValue = error
                        case .none: ()
                        }
                    })
                )
            } else {
                Text(MediaPicker.Error.noBrowsingSourceTypeAvailable.localizedDescription)
                    .foregroundColor(Color(UIColor.systemRed))
            }
        }
    }
}
#endif
