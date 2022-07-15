//
//  Photo+Camera+Result.swift
//  
//
//  Created by Christian Elies on 22.03.20.
//

#if canImport(UIKit)
import MediaCore
import UIKit

extension Photo {
    /// Namespace for Photo camera related types
    ///
    public struct Camera {}
}

extension Photo.Camera {
    /// Represents the results produced by a Photo camera
    ///
    public enum `Result` {
        /// Camera captured a photo in the format of a `UIImage`
        case tookPhoto(image: UIImage)
    }
}
#endif
