//
//  PathExtensionsProvider.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

/// Defines the requirements for a path extensions
/// provider
///
public protocol PathExtensionsProvider {
    /// Path extensions of the receiver
    var pathExtensions: [String] { get }
}
