//
//  AnyMedia.swift
//  Media
//
//  Created by Christian Elies on 04.12.19.
//

public struct AnyMedia {
    public let identifier: AnyMedia.Identifier
    public let value: Any

    init?<T: MediaProtocol>(_ media: T) {
        guard let identifier = media.identifier else { return nil }
        self.identifier = AnyMedia.Identifier(identifier)
        value = media
    }
}
