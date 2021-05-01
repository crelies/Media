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
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood.
    /// - Parameter completion: A closure which gets the selected `PHAsset` on `success` or `Error ` on `failure`.
    ///
    /// - Returns: some View
    static func browser(selectionLimit: Int = 1, _ completion: @escaping ResultPHAssetsCompletion) -> some View {
        browser(errorView: { error in Text(error.localizedDescription) }, completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    /// If an error occurs during initialization the provided `errorView` closure is used to construct the view to be displayed.
    ///
    /// - Parameter selectionLimit: Specifies the number of items which can be selected. Works only on iOS 14 and macOS 11 where the `PHPicker` is used under the hood.
    /// - Parameter errorView: A closure that constructs an error view for the given error.
    /// - Parameter completion: A closure which gets the selected `PHAsset` on `success` or `Error ` on `failure`.
    ///
    /// - Returns: some View
    @ViewBuilder static func browser<ErrorView: View>(selectionLimit: Int = 1, @ViewBuilder errorView: (Swift.Error) -> ErrorView, _ completion: @escaping ResultPHAssetsCompletion) -> some View {
        if #available(iOS 14, macOS 11, *) {
            PHPicker(configuration: {
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = selectionLimit
                return configuration
            }()) { result in
                switch result {
                case let .success(result):
                    let identifiers = result.compactMap { $0.assetIdentifier }
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                    var assets: [PHAsset] = []
                    fetchResult.enumerateObjects { asset, _, _ in
                        assets.append(asset)
                    }
                    completion(.success(assets))
                case let .failure(error): ()
                    completion(.failure(error))
                }
            }
        } else {
            if let sourceType = UIImagePickerController.availableSourceType {
                MediaPicker(sourceType: sourceType, mediaTypes: [], onSelection: { value in
                    guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                        completion(.failure(MediaPicker.Error.unsupportedValue))
                        return
                    }
                    completion(.success([phAsset]))
                }, onFailure: { error in
                    completion(.failure(error))
                })
            } else {
                errorView(MediaPicker.Error.noBrowsingSourceTypeAvailable)
            }
        }
    }
}
#endif
