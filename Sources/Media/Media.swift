//
//  Media.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

public struct Media {
    public static var isAccessAllowed: Bool {
        Media.currentPermission == .authorized
    }

    public static var currentPermission: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }

    public static func requestPermission(_ completion: @escaping (Result<Void, PermissionError>) -> Void) {
        PHPhotoLibrary.requestAuthorization { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                completion(.success(()))
            case .denied:
                completion(.failure(.denied))
            case .restricted:
                completion(.failure(.restricted))
            case .notDetermined:
                completion(.failure(.notDetermined))
            @unknown default:
                completion(.failure(.unknown))
            }
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, OSX 10.15, *)
public extension Media {
    static func browser(_ completion: @escaping (Result<Void, Error>) -> Void) throws -> some View {
        guard let sourceType = UIImagePickerController.availableSourceType else {
            throw MediaPickerError.noBrowsingSourceTypeAvailable
        }

        return MediaPicker(sourceType: sourceType, mediaTypes: []) { value in
            // TODO: please implement me
        }
    }
}
#endif
