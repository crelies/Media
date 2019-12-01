//
//  PhotosUILivePhotoView.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS) && !targetEnvironment(macCatalyst)
import PhotosUI
import SwiftUI

@available(iOS 13, tvOS 13, *)
struct PhotosUILivePhotoView: UIViewRepresentable {
    let phLivePhoto: PHLivePhoto

    func makeUIView(context: UIViewRepresentableContext<PhotosUILivePhotoView>) -> PHLivePhotoView {
        let livePhotoView = PHLivePhotoView()
        livePhotoView.livePhoto = phLivePhoto
        return livePhotoView
    }

    func updateUIView(_ uiView: PHLivePhotoView, context: UIViewRepresentableContext<PhotosUILivePhotoView>) {

    }
}
#endif
