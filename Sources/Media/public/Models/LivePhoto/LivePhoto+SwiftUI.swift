//
//  LivePhoto+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI)
import SwiftUI

#if !os(macOS) && !targetEnvironment(macCatalyst) && !os(tvOS)
@available(iOS 13, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view for capturing `LivePhoto`s
    ///
    /// - Parameter completion: a closure which gets the `URL` of the captured `LivePhoto` on `success` or `Error` on `failure`
    ///
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        try ViewCreator.camera(for: [.image, .livePhoto], completion)
    }
}
#endif

#if !os(macOS) && !os(tvOS)
@available(iOS 13, macOS 10.15, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view for browsing `LivePhoto`s in the photo library
    ///
    /// - Parameter completion: a closure which gets the selected `LivePhoto` on `success` or `Error` on `failure`
    ///
    static func browser(_ completion: @escaping (Result<LivePhoto, Error>) -> Void) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.image, .livePhoto], completion)
    }
}
#endif

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 13, tvOS 13, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    /// - Parameter size: the desired size of the `LivePhoto`
    ///
    func view(size: CGSize) -> some View {
        LivePhotoView(livePhoto: self, size: size)
    }
}
#endif

#endif
