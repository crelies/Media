//
//  FileManager+directories.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import Foundation

public extension FileManager {
    /// URL to the caches directory
    /// of the user domain
    ///
    var cachesDirectory: URL {
        urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
