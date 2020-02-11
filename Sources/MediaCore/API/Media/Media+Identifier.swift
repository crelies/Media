//
//  Media+Identifier.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension Media {
    /// Generic identifier for objects conforming
    /// to the `MediaProtocol`
    ///
    public struct Identifier<T: MediaProtocol> {
        /// Local identifier of the underlying `PHAsset`
        public let localIdentifier: String
    }
}

extension Media.Identifier: Hashable {}

extension Media.Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        localIdentifier = value
    }
}
