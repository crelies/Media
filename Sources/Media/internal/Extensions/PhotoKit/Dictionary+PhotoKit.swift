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
    var mediaType: UIImagePickerController.MediaType? {
        guard let mediaTypeString = self[Key.mediaType] as? String else {
            return nil
        }

        return try? UIImagePickerController.MediaType(string: mediaTypeString)
    }

    @available(iOS 11, *)
    var phAsset: PHAsset? { self[Key.phAsset] as? PHAsset }

    @available(iOS 11, *)
    var imageURL: URL? { self[Key.imageURL] as? URL }

    var phLivePhoto: PHLivePhoto? { self[Key.livePhoto] as? PHLivePhoto }

    var mediaURL: URL? { self[Key.mediaURL] as? URL }
}
#endif
