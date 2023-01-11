//
//  Media+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import MediaCore
import Photos
import PhotosUI
import SwiftUI

@available(iOS 13, macOS 10.15, *)
public extension Media {
    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization a `SwiftUI.Text` with the `localizedDescription` is shown.
    ///
    /// - Parameter isPresented: A binding to whether the underlying picker is presented.
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood. Defaults to `1`.
    /// - Parameter selection: A binding which represents the selected assets.
    ///
    /// - Returns: some View
    static func browser(
        isPresented: Binding<Bool>,
        selectionLimit: Int = 1,
        selection: Binding<[BrowserResult<PHAsset, NSItemProvider>]>
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
    /// - Parameter selection: A binding which represents the selected assets.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(isPresented: Binding<Bool>, selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, selection: Binding<[BrowserResult<PHAsset, NSItemProvider>]>) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(isPresented: isPresented, configuration: {
                var configuration = PHPickerConfiguration(photoLibrary: .shared())
                configuration.selectionLimit = selectionLimit
                configuration.preferredAssetRepresentationMode = .current
                return configuration
            }(), selection: .init(get: {
                []
            }, set: { browserResult in
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
            }))
        } else {
            if let sourceType = UIImagePickerController.availableSourceType {
                MediaPicker(sourceType: sourceType, mediaTypes: [], onSelection: { value in
                    guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                        // TODO: error handling
                        debugPrint(MediaPicker.Error.unsupportedValue)
                        return
                    }
                    selection.wrappedValue = [.media(phAsset, itemProvider: nil)]
                }, onFailure: { error in
                    // TODO: error handling
                    debugPrint(error)
                })
            } else {
                errorView(MediaPicker.Error.noBrowsingSourceTypeAvailable)
            }
        }
    }
}
#endif
