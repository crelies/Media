//
//  AnyMedia+Identifier.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension AnyMedia {
    public struct Identifier {
        public let localIdentifier: String

        init<T: MediaProtocol>(_ identifier: Media.Identifier<T>) {
            localIdentifier = identifier.localIdentifier
        }
    }
}
