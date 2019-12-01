//
//  UIImagePickerController+availableSourceType.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

#if canImport(UIKit) && !os(tvOS)
import UIKit

extension UIImagePickerController {
    static var availableSourceType: UIImagePickerController.SourceType? {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return .savedPhotosAlbum
        } else {
            return nil
        }
    }
}
#endif
