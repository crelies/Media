//
//  PhotosUILivePhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS) && !targetEnvironment(macCatalyst)
import PhotosUI
import SwiftUI

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
#endif
