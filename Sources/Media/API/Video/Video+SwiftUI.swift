//
//  Video+SwiftUI.swift
//  
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && !os(macOS)
import SwiftUI

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Video {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    var view: some View {
        VideoView(video: self)
    }
}

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Video {
    typealias ResultMediaURLVideoCompletion = (Result<Media.URL<Video>, Swift.Error>) -> Void

    /// Creates a ready-to-use `SwiftUI` view for capturing `Video`s
    ///
    /// - Parameter completion: a closure wich gets `Media.URL<Video>` on `success` or `Error` on `failure`
    ///
    static func camera(_ completion: @escaping ResultMediaURLVideoCompletion) throws -> some View {
        try ViewCreator.camera(for: [.movie], completion)
    }

    /// Creates a ready-to-use `SwiftUI` view for browsing `Video`s in the photo library
    ///
    /// - Parameter completion: a closure wich gets `Video` on `success` or `Error` on `failure`
    ///
    static func browser(_ completion: @escaping ResultVideoCompletion) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.movie], completion)
    }
}
#endif

#endif
