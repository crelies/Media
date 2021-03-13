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
    public typealias RequestPermissionCompletion = (Result<Void, PermissionError>) -> Void

    static var photoLibrary: PhotoLibrary.Type = PHPhotoLibrary.self

    /// Indicates that the access to the photo library is granted
    ///
    public static var isAccessAllowed: Bool {
        if #available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *) {
            return Media.currentPermission == .authorized || Media.currentPermission == .limited
        } else {
            return Media.currentPermission == .authorized
        }
    }

    /// Returns the current permission to the photo library
    ///
    public static var currentPermission: PHAuthorizationStatus {
        if #available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *) {
            return photoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return photoLibrary.authorizationStatus()
        }
    }

    /// Requests the user's permission to the photo library
    ///
    /// - Parameter completion: a closure which gets a `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    public static func requestPermission(_ completion: @escaping RequestPermissionCompletion) {
        let handler: (PHAuthorizationStatus) -> Void = { authorizationStatus in
            DispatchQueue.main.async {
                switch authorizationStatus {
                case .authorized, .limited:
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

        if #available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *) {
            photoLibrary.requestAuthorization(for: .readWrite, handler: handler)
        } else {
            photoLibrary.requestAuthorization(handler)
        }
    }

    /// Requests the user's permission to access the camera.
    ///
    /// - Parameter completion: A closure which gets a `Result` (`Void` on `success` and `Error` on `failure`).
    public static func requestCameraPermission(_ completion: @escaping RequestPermissionCompletion) {
        AVCaptureDevice.requestAccess(for: .video) { success in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(.denied))
                }
            }
        }
    }
}
