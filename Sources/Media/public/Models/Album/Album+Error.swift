//
//  Album+Error.swift
//  
//
//  Created by Christian Elies on 25.11.19.
//

import Foundation

extension Album {
    /// Errors thrown during Album operations
    ///
    public enum Error: Swift.Error {
        /// an album with the associated title already exists
        case albumWithTitleExists(_ title: String)
    }
}

extension Album.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .albumWithTitleExists(let title):
            return "An album with the title \(title) already exists."
        }
    }
}
