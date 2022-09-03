//
//  Photo+view.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import PhotosUI
import SwiftUI

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Photo {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    /// - Parameter targetSize: specifies the desired size of the photo (width and height), defaults to `nil`.
    /// - Parameter contentMode: specifies the desired content mode of the photo, defaults to `.aspectFit`.
    /// - Parameter imageView: a post processing closure which gets the `SwiftUI` `Image` view for further modification, like applying modifiers.
    ///
    /// - Returns: some `View`
    func view<ImageView: View>(targetSize: CGSize? = nil, contentMode: PHImageContentMode = .aspectFit, @ViewBuilder imageView: @escaping (Image) -> ImageView) -> some View {
        PhotoView(photo: self, targetSize: targetSize, contentMode: contentMode, imageView: imageView)
    }
}

#endif
