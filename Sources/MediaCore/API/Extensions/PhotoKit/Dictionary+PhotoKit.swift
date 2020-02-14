//
//  Dictionary+PhotoKit.swift
//  Media
//
//  Created by Christian Elies on 17.12.19.
//

#if canImport(UIKit) && !os(tvOS)
import Photos
import UIKit

extension Dictionary where Key == UIImagePickerController.InfoKey {
    /// Media type created from the underlying CFString
    /// in the info dictionary
    ///
    public var mediaType: UIImagePickerController.MediaType? {
        guard let mediaTypeString = self[Key.mediaType] as? String else {
            return nil
        }

        return try? UIImagePickerController.MediaType(string: mediaTypeString)
    }

    @available(iOS 11, *)
    /// Convenience access to the PHAsset in the info dictionary
    ///
    public var phAsset: PHAsset? { self[Key.phAsset] as? PHAsset }

    @available(iOS 11, *)
    /// Convenience access to the image URL in the info dictionary
    ///
    public var imageURL: URL? { self[Key.imageURL] as? URL }

    /// Convenience access to the PHLivePhoto in the info dictionary
    ///
    public var phLivePhoto: PHLivePhoto? { self[Key.livePhoto] as? PHLivePhoto }

    /// Convenience access to the media URL in the info dictionary
    ///
    public var mediaURL: URL? { self[Key.mediaURL] as? URL }
}
#endif
