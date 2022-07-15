//
//  Audio+FileType.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension Audio {
    /// Represents the file types for `Audio`s
    ///
    public enum FileType: String, CaseIterable {
        case none
    }
}

extension Audio.FileType: PathExtensionsProvider {
    /// Path extensions of the receiver
    ///
    public var pathExtensions: [String] { [] }
}
