//
//  NSItemProvider+Error.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 03.05.21.
//

import Foundation

extension NSItemProvider {
    /// Represents the errors thrown if loading data from the receiving item provider fails.
    public enum Error: Swift.Error {
        /// The requested object could not be loaded.
        case couldNotLoadObject(underlying: Swift.Error)
        /// An unknown error occurred.
        case unknown
    }
}
