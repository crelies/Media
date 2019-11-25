//
//  AlbumError.swift
//  
//
//  Created by Christian Elies on 25.11.19.
//

import Foundation

public enum AlbumError: Error {
    case albumWithTitleExists
}

extension AlbumError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .albumWithTitleExists:
            return "An album with the given title already exists."
        }
    }
}
