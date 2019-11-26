//
//  UIImagePickerController+MediaType.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

import CoreServices
import UIKit

extension UIImagePickerController {
    enum MediaType {
        case image
        case livePhoto
        case movie

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

        init(string: String) throws {
            switch string as CFString {
            case CFString.image:
                self = MediaType.image
            case CFString.livePhoto:
                self = MediaType.livePhoto
            case CFString.movie:
                self = MediaType.movie
            default:
                throw MediaTypeError.unsupportedString
            }
        }
    }
}
