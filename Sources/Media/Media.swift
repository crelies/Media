//
//  Media.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Provides  convenience functionality, like the current permission
/// for the photos library
///
public struct Media {
    /// Indicates that the access to the photo library is granted
    ///
    public static var isAccessAllowed: Bool {
        Media.currentPermission == .authorized
    }

    /// Returns the current permission to the photo library
    ///
    public static var currentPermission: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }

    /// Requests the user's permission to the photo library
    ///
    /// - Parameter completion: a closure which gets a `Result` (`Void` on `success` and `Error` on `failure`)
    ///
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
