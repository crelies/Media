//
//  ImagePicker+Coordinator.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI)
import Photos
import UIKit

@available(iOS 13, OSX 10.15, tvOS 13, *)
extension ImagePicker {
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let imagePicker: ImagePicker

        init(imagePicker: ImagePicker) {
            self.imagePicker = imagePicker
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
            guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? NSString else {
                picker.dismiss(animated: true, completion: nil)
                return
            }

            switch (picker.sourceType, mediaType as CFString) {
            case (.camera, .image):
                guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let imagePickerValue: ImagePickerValue = .tookPhoto(url: imageURL)
                imagePicker.onSelection(imagePickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.camera, .livePhoto):
                guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let imagePickerValue: ImagePickerValue = .tookLivePhoto(url: imageURL)
                imagePicker.onSelection(imagePickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.camera, .movie):
                guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let imagePickerValue: ImagePickerValue = .tookVideo(url: mediaURL)
                imagePicker.onSelection(imagePickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.photoLibrary, .image), (.savedPhotosAlbum, .image):
                guard let phAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let photo = Photo(phAsset: phAsset)
                let imagePickerValue: ImagePickerValue = .selectedPhoto(photo)
                imagePicker.onSelection(imagePickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.photoLibrary, .livePhoto), (.savedPhotosAlbum, .livePhoto):
                guard let phAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let livePhoto = LivePhoto(phAsset: phAsset)
                let imagePickerValue: ImagePickerValue = .selectedLivePhoto(livePhoto)
                imagePicker.onSelection(imagePickerValue)
                picker.dismiss(animated: true, completion: nil)

            case (.photoLibrary, .movie), (.savedPhotosAlbum, .movie):
                guard let phAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }

                let video = Video(phAsset: phAsset)
                let imagePickerValue: ImagePickerValue = .selectedVideo(video)
                imagePicker.onSelection(imagePickerValue)
                picker.dismiss(animated: true, completion: nil)

            default:
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}
#endif
