//
//  Audio+FileType.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension Audio {
    public enum FileType: String, CaseIterable {
        case none
    }
}

extension Audio.FileType: PathExtensionsProvider {
    public var pathExtensions: [String] { [] }
}
