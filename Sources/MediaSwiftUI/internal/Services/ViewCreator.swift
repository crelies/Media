//
//  ViewCreator.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
import MediaCore
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, *)
struct ViewCreator {
    static func camera<T: MediaProtocol>(
        for mediaTypes: Set<UIImagePickerController.MediaType>,
        _ completion: @escaping ResultMediaURLCompletion<T>) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw Camera.Error.noCameraAvailable
        }

        return MediaPicker(sourceType: .camera, mediaTypes: mediaTypes) { value in
            switch value {
            case .tookPhoto(let url), .tookVideo(let url):
                do {
                    let mediaURL = try Media.URL<T>(url: url)
                    completion(.success(mediaURL))
                } catch {
                    completion(.failure(error))
                }
            default:
                completion(.failure(MediaPicker.Error.unsupportedValue))
            }
        }
    }

    static func browser<T: MediaProtocol>(mediaTypes: Set<UIImagePickerController.MediaType>,
                                          _ completion: @escaping ResultGenericCompletion<T>) throws -> some View {
        guard let sourceType = UIImagePickerController.availableSourceType else {
            throw MediaPicker.Error.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: mediaTypes) { value in
            guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                completion(.failure(MediaPicker.Error.unsupportedValue))
                return
            }
            let media = T.init(phAsset: phAsset)
            completion(.success(media))
        }
    }
}
#endif
