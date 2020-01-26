//
//  Media+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import Photos
import SwiftUI

@available(iOS 13, macOS 10.15, *)
public extension Media {
    typealias ResultPHAssetCompletion = (Result<PHAsset, Swift.Error>) -> Void

    /// Creates a ready-to-use `SwiftUI` view for browsing the photo library
    ///
    /// - Parameter completion: a closure which gets the selected `PHAsset` on `success` or `Error ` on `failure`
    ///
    static func browser(_ completion: @escaping ResultPHAssetCompletion) throws -> some View {
        guard let sourceType = UIImagePickerController.availableSourceType else {
            throw MediaPicker.Error.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: []) { value in
            guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                completion(.failure(MediaPicker.Error.unsupportedValue))
                return
            }
            completion(.success(phAsset))
        }
    }
}
#endif
