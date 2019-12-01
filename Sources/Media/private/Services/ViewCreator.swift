//
//  ViewCreator.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, OSX 10.15, tvOS 13, *)
struct ViewCreator {
    static func camera(for mediaTypes: [UIImagePickerController.MediaType],
                       _ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw CameraError.noCameraAvailable
        }

        return MediaPicker(sourceType: .camera, mediaTypes: mediaTypes) { value in
            guard case let MediaPickerValue.tookMedia(imageURL) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(imageURL))
        }
    }

    static func browser<T: AbstractMedia>(for type: T.Type,
                                          mediaTypes: [UIImagePickerController.MediaType],
                                          _ completion: @escaping (Result<T, Error>) -> Void) throws -> some View {
        guard let sourceType = UIImagePickerController.availableSourceType else {
            throw MediaPickerError.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: mediaTypes) { value in
            guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            let media = type.init(phAsset: phAsset)
            completion(.success(media))
        }
    }
}
#endif
