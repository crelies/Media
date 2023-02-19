//
//  PermissionError.swift
//  MediaCore
//
//  Created by Christian Elies on 22.11.19.
//

import Foundation

/// Errors thrown during permission requests
/// Like `PHAuthorizationStatus` but without `unknown` case
///
public enum PermissionError: Error {
    /// Thrown if the permission was denied
    case denied
    /// Thrown if the permission could not be determined
    case notDetermined
    /// Thrown if the access was restricted
    case restricted
    /// Thrown if an unknown error occurred
    case unknown
}

extension PermissionError: LocalizedError {
    /// Description for the receiving error
    ///
    public var errorDescription: String? {
        switch self {
        case .denied:
            return "The user has explicitly denied your app access to the photo library."
        case .notDetermined:
            return "Explicit user permission is required for photo library access, but the user has not yet granted or denied such permission."
        case .restricted:
            return "Your app is not authorized to access the photo library, and the user cannot grant such permission."
        default:
            return nil
        }
    }
}
