//
//  MediaTypeError.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(UIKit) && !os(tvOS)
import UIKit

extension UIImagePickerController {
    enum MediaTypeError: Error {
        /// Thrown if the string is unsupported
        case unsupportedString
    }
}
#endif
