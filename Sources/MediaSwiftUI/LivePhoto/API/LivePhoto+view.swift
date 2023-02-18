//
//  LivePhoto+view.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 02.12.19.
//

#if canImport(SwiftUI)
import CoreGraphics
import MediaCore
import SwiftUI

#if !targetEnvironment(macCatalyst)
@available(iOS 14, macOS 11, tvOS 14, *)
public extension LivePhoto {
    /// Creates a ready-to-use `SwiftUI` view representation of the receiver
    ///
    /// - Parameter size: the desired size of the `LivePhoto`
    ///
    @ViewBuilder
    func view(size: CGSize) -> some View {
        let viewModel = LivePhotoViewModel(livePhoto: self, size: size)
        LivePhotoView(viewModel: viewModel)
    }
}
#endif

#endif
