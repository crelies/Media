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
    var view: some View {
        VideoView(video: self)
    }
}

#if !os(tvOS)
@available (iOS 13, macOS 10.15, *)
public extension Video {
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        try ViewCreator.camera(for: [.movie], completion)
    }

    static func browser(_ completion: @escaping (Result<Video, Error>) -> Void) throws -> some View {
        try ViewCreator.browser(mediaTypes: [.movie], completion)
    }

    // TODO: UIVideoEditorController
//    static func editor() -> some View {
//        EmptyView()
//    }
}
#endif

#endif
