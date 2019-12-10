//
//  UIImagePickerController+supportedMediaTypes.swift
//  Media
//
//  Created by Christian Elies on 10.12.19.
//

#if canImport(UIKit) && !os(tvOS)
import UIKit

extension UIImagePickerController {
    static func supportedMediaTypes(from mediaTypes: [UIImagePickerController.MediaType],
                                    sourceType: UIImagePickerController.SourceType) -> [String]? {
        guard let availableMediaTypes = Self.availableMediaTypes(for: sourceType) else {
            return nil
        }

        guard !availableMediaTypes.isEmpty else {
            return nil
        }

        var supportedMediaTypes: [String]?
        if !mediaTypes.isEmpty {
            let imagePickerViewControllerMediaTypes: [String] = mediaTypes.map { $0.cfString as String}.filter { availableMediaTypes.contains($0) }
            if !imagePickerViewControllerMediaTypes.isEmpty {
                supportedMediaTypes = imagePickerViewControllerMediaTypes
            }
        } else {
            supportedMediaTypes = availableMediaTypes
        }

        return supportedMediaTypes
    }
}
#endif
