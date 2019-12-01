//
//  Camera.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI)
import SwiftUI
import UIKit

@available(iOS 13, OSX 10.15, *)
public struct Camera {
    public static func view(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw CameraError.noCameraAvailable
        }

        let availableMediaTypes = try (UIImagePickerController.availableMediaTypes(for: .camera) ?? []).map { try UIImagePickerController.MediaType(string: $0) }

        return MediaPicker(sourceType: .camera, mediaTypes: availableMediaTypes) { value in
            switch value {
            case .tookMedia(let url):
                completion(.success(url))
            default: ()
            }
        }
    }
}
#endif
