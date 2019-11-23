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
