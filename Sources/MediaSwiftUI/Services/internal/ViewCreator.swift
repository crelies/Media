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
    static func camera(
        for mediaTypes: Set<UIImagePickerController.MediaType>,
        _ completion: @escaping (Result<Camera.Result, Swift.Error>) -> Void) throws -> MediaPicker {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw Camera.Error.noCameraAvailable
        }

        return MediaPicker(
            sourceType: .camera,
            mediaTypes: mediaTypes,
            selection: .writeOnly({ result in
                switch result {
                case let .success(value):
                    switch value {
                    case .tookPhoto(let image):
                        completion(.success(.tookPhoto(image: image)))
                    case .tookVideo(let url):
                        completion(.success(.tookVideo(url: url)))
                    default:
                        completion(.failure(MediaPicker.Error.unsupportedValue))
                    }
                case let .failure(error):
                    completion(.failure(error))
                case .none: ()
                }
            })
        )
    }

    static func browser<T: MediaProtocol>(
        mediaTypes: Set<UIImagePickerController.MediaType>,
        _ completion: @escaping ResultGenericCompletion<T>
    ) throws -> MediaPicker {
        guard let sourceType = UIImagePickerController.availableSourceType else {
            throw MediaPicker.Error.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(
            sourceType: sourceType,
            mediaTypes: mediaTypes,
            selection: .writeOnly({ result in
                switch result {
                case let .success(value):
                    guard case let MediaPickerValue.selectedMedia(phAsset) = value else {
                        completion(.failure(MediaPicker.Error.unsupportedValue))
                        return
                    }
                    let media = T.init(phAsset: phAsset)
                    completion(.success(media))
                case let .failure(error):
                    completion(.failure(error))
                case .none: ()
                }
            })
        )
    }
}
#endif
