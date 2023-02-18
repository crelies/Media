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
    @ViewBuilder
    static func camera(
        for mediaTypes: Set<UIImagePickerController.MediaType>,
        selection: Binding<Result<Camera.Result, Swift.Error>?>
    ) -> some View {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            MediaPicker(
                sourceType: .camera,
                mediaTypes: mediaTypes,
                selection: .writeOnly({ result in
                    switch result {
                    case let .success(value):
                        switch value {
                        case .tookPhoto(let image):
                            selection.wrappedValue = .success(.tookPhoto(image: image))
                        case .tookVideo(let url):
                            selection.wrappedValue = .success(.tookVideo(url: url))
                        default:
                            selection.wrappedValue = .failure(MediaPicker.Error.unsupportedValue)
                        }
                    case let .failure(error):
                        selection.wrappedValue = .failure(error)
                    case .none: ()
                    }
                })
            )
        } else {
            Text(Camera.Error.noCameraAvailable.localizedDescription)
        }
    }

    @ViewBuilder
    static func browser<T: MediaProtocol>(
        mediaTypes: Set<UIImagePickerController.MediaType>,
        _ completion: @escaping ResultGenericCompletion<T>
    ) -> some View {
        if let sourceType = UIImagePickerController.availableSourceType {
            MediaPicker(
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
        } else {
            Text(MediaPicker.Error.noBrowsingSourceTypeAvailable.localizedDescription)
        }
    }
}
#endif
