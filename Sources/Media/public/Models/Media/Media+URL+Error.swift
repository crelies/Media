//
//  Media+URL+Error.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

import Foundation

extension Media.URL {
    public enum Error: Swift.Error {
        /// Thrown if a file type could not be created
        case couldNotCreateFileType
        /// Thrown if a path extension is missing
        case missingPathExtension
        /// Thrown if the path extension is unsupported
        case unsupportedPathExtension
    }
}
