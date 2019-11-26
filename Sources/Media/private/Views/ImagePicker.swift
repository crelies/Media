//
//  ImagePicker.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

#if canImport(SwiftUI)
import Foundation
import Photos
import SwiftUI

@available(iOS 13, OSX 10.15, tvOS 13, *)
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let mediaTypes: [UIImagePickerController.MediaType]
    let onSelection: (ImagePickerValue) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
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
        Coordinator(imagePicker: self)
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}

#if DEBUG
@available(iOS 13, OSX 10.15, tvOS 13, *)
struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(sourceType: .savedPhotosAlbum, mediaTypes: []) { value in

        }
    }
}
#endif

#endif
