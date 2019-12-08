//
//  LivePhoto+FileType.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension LivePhoto {
    public enum FileType: String, CaseIterable {
        case none
    }
}

extension LivePhoto.FileType: PathExtensionsProvider {
    public var pathExtensions: [String] { [] }
}
