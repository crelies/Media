//
//  MediaPicker.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
import UIKit

@available(iOS 13, OSX 10.15, *)
struct MediaPicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let mediaTypes: [UIImagePickerController.MediaType]
    let onSelection: (MediaPickerValue) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<MediaPicker>) -> UIImagePickerController {
        let imagePickerViewController = UIImagePickerController()

        if !mediaTypes.isEmpty {
            imagePickerViewController.mediaTypes = mediaTypes.map { ($0.cfString as String) }
        } else if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType), !availableMediaTypes.isEmpty {
            imagePickerViewController.mediaTypes = availableMediaTypes
        }

        imagePickerViewController.sourceType = sourceType
        imagePickerViewController.delegate = context.coordinator

        return imagePickerViewController
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(mediaPicker: self)
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MediaPicker>) {

    }
}

#if DEBUG
@available(iOS 13, OSX 10.15, *)
struct MediaPicker_Previews: PreviewProvider {
    static var previews: some View {
        MediaPicker(sourceType: .savedPhotosAlbum, mediaTypes: []) { value in

        }
    }
}
#endif

#endif
