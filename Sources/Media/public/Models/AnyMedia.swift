//
//  AnyMedia.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

public struct AnyMedia {
    public let identifier: AnyMediaIdentifier
    public let value: Any

    init<T: MediaProtocol>(_ media: T) {
        identifier = AnyMediaIdentifier(media.identifier)
        value = media
    }
}
