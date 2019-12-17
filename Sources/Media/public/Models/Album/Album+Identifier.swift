//
//  Album+Identifier.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

// TODO: 10.13
@available(macOS 10.15, *)
extension Album {
    public struct Identifier {
        public let localIdentifier: String
    }
}

// TODO: 10.13
@available(macOS 10.15, *)
extension Album.Identifier: Hashable {}

// TODO: 10.13
@available(macOS 10.15, *)
extension Album.Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        localIdentifier = value
    }
}

// TODO: 10.13
@available(macOS 10.15, *)
extension Album.Identifier: CustomStringConvertible {
    public var description: String { localIdentifier }
}
