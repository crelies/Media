//
//  PermissionError.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Foundation

public enum PermissionError: Error {
    case denied
    case notDetermined
    case restricted
    case unknown
}

extension PermissionError: LocalizedError {
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
