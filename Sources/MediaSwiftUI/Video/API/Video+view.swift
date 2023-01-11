//
//  Video+view.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI) && (!os(macOS) || targetEnvironment(macCatalyst))
import MediaCore
import SwiftUI

@available (iOS 14, macOS 11, tvOS 14, *)
public extension Video {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    @ViewBuilder
    var view: some View {
        let viewModel = VideoViewModel(video: self)
        VideoView(viewModel: viewModel)
    }
}
#endif
