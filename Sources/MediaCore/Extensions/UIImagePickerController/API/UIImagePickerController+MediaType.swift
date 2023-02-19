//
//  UIImagePickerController+MediaType.swift
//  MediaCore
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(UIKit) && !os(tvOS)
import CoreServices
import UIKit

public extension UIImagePickerController {
    /// Represents the different media types
    /// supported by a UIImagePickerController
    ///
    enum MediaType: CaseIterable {
        case image
        case livePhoto
        case movie
    }
}

extension UIImagePickerController.MediaType {
    var cfString: CFString {
        switch self {
        case .image:
            return CFString.image
        case .livePhoto:
            return CFString.livePhoto
        case .movie:
            return CFString.movie
        }
    }

    /// Initializes a media type using the given string (CFString)
    ///
    /// - Parameter string: the string (CFString) which represents the media type
    /// - Throws: an error if the string is not a valid media type string (CFString)
    ///
    public init(string: String) throws {
        switch string as CFString {
        case CFString.image:
            self = UIImagePickerController.MediaType.image
        case CFString.livePhoto:
            self = UIImagePickerController.MediaType.livePhoto
        case CFString.movie:
            self = UIImagePickerController.MediaType.movie
        default:
            throw UIImagePickerController.MediaTypeError.unsupportedString
        }
    }
}
#endif
