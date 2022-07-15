//
//  Album+Identifier.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension Album {
    /// Identifier type for an album
    ///
    public struct Identifier {
        /// Local identifier of the underlying `PHAssetCollection`
        public let localIdentifier: String
    }
}

extension Album.Identifier: Hashable {}

extension Album.Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        localIdentifier = value
    }
}
