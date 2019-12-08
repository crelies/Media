//
//  Media+Identifier.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension Media {
    public struct Identifier {
        public let localIdentifier: String
    }
}

extension Media.Identifier: Hashable {}

extension Media.Identifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        localIdentifier = value
    }
}

extension Media.Identifier: CustomStringConvertible {
    public var description: String { localIdentifier }
}
