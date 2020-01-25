//
//  AnyMedia.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

public struct AnyMedia {
    public let identifier: AnyMedia.Identifier
    public let value: Any

    init<T: MediaProtocol>(_ media: T) {
        identifier = AnyMedia.Identifier(media.identifier)
        value = media
    }
}
