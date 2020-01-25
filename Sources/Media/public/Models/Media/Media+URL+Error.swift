//
//  Media+URL+Error.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

import Foundation

extension Media.URL {
    public enum Error: Swift.Error {
        case couldNotCreateFileType
        case missingPathExtension
        case unsupportedPathExtension
    }
}
