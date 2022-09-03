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
