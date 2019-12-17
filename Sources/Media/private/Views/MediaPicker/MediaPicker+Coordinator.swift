//
//  MediaPicker+Coordinator.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import Photos
import UIKit

@available(iOS 13, macOS 10.15, *)
extension MediaPicker {
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let mediaPicker: MediaPicker

        init(mediaPicker: MediaPicker) {
            self.mediaPicker = mediaPicker
        }

        /*
            On compatible devices, the Camera app captures all photos as Live Photos by default, but the
            imagePickerController:didFinishPickingImage:editingInfo: method’s image parameter contains only
            the still image representation.
            To obtain the motion and sound content of a live photo for display (using the PHLivePhotoView class), include the
            kUTTypeImage and kUTTypeLivePhoto identifiers in the allowed media types when configuring an image picker
            controller. When the user picks or captures a Live Photo, the editingInfo dictionary contains the livePhoto key,
            with a PHLivePhoto representation of the photo as the corresponding value.
         */
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            guard let mediaType = info.mediaType else {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            switch (picker.sourceType, mediaType) {
            case (.camera, .image),
                 (.camera, .movie):
                guard let imageURL = info.imageURL else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let mediaPickerValue: MediaPickerValue = .tookMedia(url: imageURL)
                mediaPicker.onSelection(mediaPickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.camera, .livePhoto):
                guard let imageURL = info.imageURL else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                guard let livePhoto = info.phLivePhoto else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let mediaPickerValue: MediaPickerValue = .tookLivePhoto(livePhoto, url: imageURL)
                mediaPicker.onSelection(mediaPickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.photoLibrary, .image),
                 (.savedPhotosAlbum, .image),
                 (.photoLibrary, .movie),
                 (.savedPhotosAlbum, .movie):
                guard let phAsset = info.phAsset else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let mediaPickerValue: MediaPickerValue = .selectedMedia(phAsset: phAsset)
                mediaPicker.onSelection(mediaPickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.photoLibrary, .livePhoto),
                 (.savedPhotosAlbum, .livePhoto):
                guard let phAsset = info.phAsset else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                guard let livePhoto = info.phLivePhoto else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let mediaPickerValue: MediaPickerValue = .selectedLivePhoto(livePhoto, phAsset: phAsset)
                mediaPicker.onSelection(mediaPickerValue)
                picker.dismiss(animated: true, completion: nil)

            default:
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}
#endif
