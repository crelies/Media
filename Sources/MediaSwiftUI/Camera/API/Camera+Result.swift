//
//  Camera+Result.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 22.03.20.
//

#if canImport(UIKit) && !os(tvOS)
import UIKit

@available(iOS 13, macOS 10.15, *)
extension Camera {
    /// Represents the results produced by a camera
    ///
    public enum `Result` {
        /// A photo was taken by the camera, the associated value is a `UIImage`
        case tookPhoto(image: UIImage)
        /// A video was taken by the camera, the associated value is the `URL` of the video
        case tookVideo(url: URL)
    }
}
#endif
