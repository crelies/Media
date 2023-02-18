//
//  PhotosUILivePhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI)
import PhotosUI
import SwiftUI

#if !os(macOS) && !targetEnvironment(macCatalyst)
@available(iOS 13, tvOS 13, *)
/// `SwiftUI` port of the `PHLivePhotoView`.
public struct PhotosUILivePhotoView: UIViewRepresentable {
    let phLivePhoto: PHLivePhoto

    /// Initializes the view with the given live photo.
    ///
    /// - Parameter phLivePhoto: The live photo which should be displayed.
    public init(phLivePhoto: PHLivePhoto) {
        self.phLivePhoto = phLivePhoto
    }

    public func makeUIView(context: UIViewRepresentableContext<PhotosUILivePhotoView>) -> PHLivePhotoView {
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = phLivePhoto
        return livePhotoView
    }

    public func updateUIView(_ uiView: PHLivePhotoView, context: UIViewRepresentableContext<PhotosUILivePhotoView>) {}
}
#elseif os(macOS)
/// `SwiftUI` port of the `PHLivePhotoView`.
public struct PhotosUILivePhotoView: NSViewRepresentable {
    let phLivePhoto: PHLivePhoto

    /// Initializes the view with the given live photo.
    ///
    /// - Parameter phLivePhoto: The live photo which should be displayed.
    public init(phLivePhoto: PHLivePhoto) {
        self.phLivePhoto = phLivePhoto
    }

    public func makeNSView(context: NSViewRepresentableContext<PhotosUILivePhotoView>) -> PHLivePhotoView {
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = phLivePhoto
        return livePhotoView
    }

    public func updateNSView(_ nsView: PHLivePhotoView, context: NSViewRepresentableContext<PhotosUILivePhotoView>) {}
}
#endif

#endif
