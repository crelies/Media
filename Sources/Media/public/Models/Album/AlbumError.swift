//
//  AlbumError.swift
//  
//
//  Created by Christian Elies on 25.11.19.
//

import Foundation

/// Errors thrown during Album operations
///
public enum AlbumError: Error {
    /// an album with the associated title already exists
    case albumWithTitleExists(_ title: String)
}

extension AlbumError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .albumWithTitleExists(let title):
            return "An album with the title \(title) already exists."
        }
    }
}
