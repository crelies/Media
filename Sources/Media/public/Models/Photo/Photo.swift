//
//  Photo.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct Photo: AbstractMedia {
    public let phAsset: PHAsset

    public let type: MediaType = .image
    public var isFavorite: Bool { phAsset.isFavorite }

    public init(phAsset: PHAsset) {
        self.phAsset = phAsset
    }
}

public extension Photo {
    var subtypes: [PhotoSubtype] {
        var types: [PhotoSubtype] = []

        if #available(iOS 10.2, OSX 10.11, tvOS 9, *) {
            switch phAsset.mediaSubtypes {
            case [.photoDepthEffect, .photoScreenshot, .photoHDR, .photoPanorama]:
                types.append(contentsOf: [.depthEffect, .screenshot, .hdr, .panorama])

            case [.photoDepthEffect, .photoScreenshot, .photoHDR]:
                types.append(contentsOf: [.depthEffect, .screenshot, .hdr])

            case [.photoDepthEffect, .photoScreenshot]:
                types.append(contentsOf: [.depthEffect, .screenshot])
            case [.photoDepthEffect, .photoHDR]:
                types.append(contentsOf: [.depthEffect, .hdr])
            case [.photoDepthEffect, .photoPanorama]:
                types.append(contentsOf: [.depthEffect, .panorama])
            case [.photoScreenshot, .photoHDR]:
                types.append(contentsOf: [.screenshot, .hdr])
            case [.photoScreenshot, .photoPanorama]:
                types.append(contentsOf: [.screenshot, .panorama])
            case [.photoHDR, .photoPanorama]:
                types.append(contentsOf: [.hdr, .panorama])

            case [.photoDepthEffect]:
                types.append(.depthEffect)
            case [.photoScreenshot]:
                types.append(.screenshot)
            case [.photoHDR]:
                types.append(.hdr)
            case [.photoPanorama]:
                types.append(.panorama)
            default: ()
            }
        } else {
            switch phAsset.mediaSubtypes {
            case [.photoScreenshot, .photoHDR, .photoPanorama]:
                types.append(contentsOf: [.screenshot, .hdr, .panorama])

            case [.photoScreenshot, .photoHDR]:
                types.append(contentsOf: [.screenshot, .hdr])
            case [.photoScreenshot, .photoPanorama]:
                types.append(contentsOf: [.screenshot, .panorama])
            case [.photoHDR, .photoPanorama]:
                types.append(contentsOf: [.hdr, .panorama])

            case [.photoScreenshot]:
                types.append(.screenshot)
            case [.photoHDR]:
                types.append(.hdr)
            case [.photoPanorama]:
                types.append(.panorama)
            default: ()
            }
        }

        return types
    }
}

public extension Photo {
    func data(_ completion: @escaping (Result<Data, Error>) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        if #available(iOS 13, *) {
            PHImageManager.default().requestImageDataAndOrientation(for: phAsset, options: options, resultHandler: { data, _, _, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(PhotosError.unknown))
                }
            })
        } else {
            // Fallback on earlier versions
            phAsset.requestContentEditingInput(with: nil) { contentEditingInput, _ in
                guard let fullSizeImageURL = contentEditingInput?.fullSizeImageURL else {
                    completion(.failure(PhotoError.missingFullSizeImageURL))
                    return
                }

                do {
                    let data = try Data(contentsOf: fullSizeImageURL)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    func uiImage(targetSize: CGSize,
                 contentMode: PHImageContentMode,
                 _ completion: @escaping (Result<Photo.DisplayRepresentation, Error>) -> Void) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: phAsset,
                                              targetSize: targetSize,
                                              contentMode: contentMode,
                                              options: options)
        { image, info in
            if let error = info?[PHImageErrorKey] as? Error {
                completion(.failure(error))
            } else if let image = image {
                let imageResultIsDegraded = info?[PHImageResultIsDegradedKey] as? NSNumber
                switch imageResultIsDegraded?.boolValue {
                    case .none:
                        let displayRepresentation = Photo.DisplayRepresentation(uiImage: image, quality: .high)
                        completion(.success(displayRepresentation))
                    case .some(let booleanValue):
                        if booleanValue {
                            let displayRepresentation = Photo.DisplayRepresentation(uiImage: image, quality: .low)
                            completion(.success(displayRepresentation))
                        } else {
                            let displayRepresentation = Photo.DisplayRepresentation(uiImage: image, quality: .high)
                            completion(.success(displayRepresentation))
                        }
                }
            } else {
                completion(.failure(PhotosError.unknown))
            }
        }
    }
}

public extension Photo {
    // TODO: determine file type
    static func save(_ url: URL, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        var placeholderForCreatedAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
            if let placeholder = creationRequest?.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let photo = Self.with(identifier: localIdentifier) {
                    completion(.success(photo))
                } else {
                    completion(.failure(PhotosError.unknown))
                }
            }
        })
    }

    static func save(_ image: UIImage, completion: @escaping (Result<Photo, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }
        
        var placeholderForCreatedAsset: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let placeholder = creationRequest.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? PhotosError.unknown))
            } else {
                if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let photo = Self.with(identifier: localIdentifier) {
                    completion(.success(photo))
                } else {
                    completion(.failure(PhotosError.unknown))
                }
            }
        })
    }

    func favorite(_ favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        PHAssetChanger.favorite(phAsset: phAsset, favorite: favorite, completion)
    }

    static func with(identifier: String) -> Photo? {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "localIdentifier = %@ && mediaType = %d", identifier, MediaType.image.rawValue)
        options.predicate = predicate

        let photo = PHAssetFetcher.fetchAsset(Photo.self, options: options) { asset in
            if asset.localIdentifier == identifier && asset.mediaType == .image {
                return true
            }
            return false
        }
        return photo
    }
}

public extension Photo {
    // TODO:
    func edit(_ change: @escaping (inout PHContentEditingInput?) -> Void, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable {
        let options = PHContentEditingInputRequestOptions()
        let contentEditingInputRequestID = phAsset.requestContentEditingInput(with: options) { contentEditingInput, info in
            var contentEditingInput = contentEditingInput
            change(&contentEditingInput)

            if let editingInput = contentEditingInput {
                guard Media.isAccessAllowed else {
                    completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
                    return
                }

                let output = PHContentEditingOutput(contentEditingInput: editingInput)

                PHPhotoLibrary.shared().performChanges({
                    let assetChangeRequest = PHAssetChangeRequest(for: self.phAsset)
                    assetChangeRequest.contentEditingOutput = output
                }) { isSuccess, error in
                    if !isSuccess {
                        completion(.failure(error ?? PhotosError.unknown))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }

        return {
            self.phAsset.cancelContentEditingInputRequest(contentEditingInputRequestID)
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available (iOS 13, OSX 10.15, *)
public extension Photo {
    static func camera(_ completion: @escaping (Result<URL, Error>) -> Void) throws -> some View {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw CameraError.noCameraAvailable
        }

        return MediaPicker(sourceType: .camera, mediaTypes: [.image]) { value in
            guard case let MediaPickerValue.tookPhoto(imageURL) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(imageURL))
        }
    }

    static func browser(_ completion: @escaping (Result<Photo, Error>) -> Void) throws -> some View {
        var sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            sourceType = .photoLibrary
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            sourceType = .savedPhotosAlbum
        } else {
            throw MediaPickerError.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: [.image]) { value in
            guard case let MediaPickerValue.selectedPhoto(photo) = value else {
                completion(.failure(MediaPickerError.unsupportedValue))
                return
            }
            completion(.success(photo))
        }
    }

    func view<ImageView: View>(@ViewBuilder imageView: @escaping (Image) -> ImageView) -> some View {
        PhotoView(photo: self, imageView: imageView)
    }
}
#endif
