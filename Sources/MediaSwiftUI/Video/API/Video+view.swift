//
//  Video+view.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import SwiftUI

@available (iOS 13, macOS 10.15, tvOS 13, *)
public extension Video {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    var view: some View {
        VideoView(video: self)
    }
}
#endif
