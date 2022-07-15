//
//  LivePhoto+FileType.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension LivePhoto {
    /// Represents the file types
    /// of a live photo used by this
    /// Swift package
    ///
    public enum FileType: String, CaseIterable {
        case mov
    }
}

extension LivePhoto.FileType: PathExtensionsProvider {
    /// Path extensions for the receiving
    /// live photo file type
    ///
    public var pathExtensions: [String] { [rawValue] }
}
