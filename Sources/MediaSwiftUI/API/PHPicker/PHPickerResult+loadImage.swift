//
//  PHPickerResult+loadImage.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 14.10.20.
//

import PhotosUI

@available(iOS 14, macOS 11, macCatalyst 14, *)
extension PHPickerResult {
    public enum Error: Swift.Error {
        case couldNotLoadObject(underlying: Swift.Error)
    }

    public func loadImage(_ completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            // TODO:
            return
        }

        itemProvider.loadObject(ofClass: UIImage.self) { newImage, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(Error.couldNotLoadObject(underlying: error)))
                }
            } else if let newImage = newImage {
                DispatchQueue.main.async {
                    completion(.success(newImage as! UIImage))
                }
            }
        }
    }
}
