//
//  Authorization+PermissionError.swift
//  
//
//  Created by Christian Elies on 24.11.19.
//

import Foundation
import Photos

extension PHAuthorizationStatus {
    public var permissionError: PermissionError? {
        switch self {
        case .denied:
            return PermissionError.denied
        case .notDetermined:
            return PermissionError.notDetermined
        case .restricted:
            return PermissionError.restricted
        default:
            return nil
        }
    }
}
