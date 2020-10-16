//
//  MediaPicker.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
struct MediaPicker: UIViewControllerRepresentable {
    static var imagePickerControllerType: UIImagePickerController.Type = UIImagePickerController.self

    let sourceType: UIImagePickerController.SourceType
    let mediaTypes: Set<UIImagePickerController.MediaType>
    let onSelection: (MediaPickerValue) -> Void
    let onFailure: (MediaPicker.Error) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<MediaPicker>) -> UIImagePickerController {
        let imagePickerViewController = Self.imagePickerControllerType.init()

        if let mediaTypes = Self.imagePickerControllerType.supportedMediaTypes(from: mediaTypes, sourceType: sourceType) {
            imagePickerViewController.mediaTypes = mediaTypes
        }

        imagePickerViewController.sourceType = sourceType
        imagePickerViewController.delegate = context.coordinator

        return imagePickerViewController
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(mediaPicker: self)
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<MediaPicker>
    ) {}
}

#if DEBUG
@available(iOS 13, macOS 10.15, *)
struct MediaPicker_Previews: PreviewProvider {
    static var previews: some View {
        MediaPicker(sourceType: .savedPhotosAlbum, mediaTypes: [], onSelection: { _ in }, onFailure: { _ in })
    }
}
#endif

#endif
