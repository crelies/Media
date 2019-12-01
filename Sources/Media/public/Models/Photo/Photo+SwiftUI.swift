//
//  Photo+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && !os(macOS)
import SwiftUI

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Photo {
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        try ViewCreator.camera(for: [.image], completion)
    }

    static func browser(_ completion: @escaping (Result<Photo, Error>) -> Void) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.image], completion)
    }
}
#endif

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Photo {
    func view<ImageView: View>(@ViewBuilder imageView: @escaping (Image) -> ImageView) -> some View {
        PhotoView(photo: self, imageView: imageView)
    }
}

#endif
