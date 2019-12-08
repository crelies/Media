//
//  AnyMedia.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

public struct AnyMedia {
    let identifier: Media.Identifier

    public let value: Any

    init<T: MediaProtocol>(_ media: T) {
        identifier = media.identifier
        value = media
    }
}
