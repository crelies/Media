//
//  AnyMedia.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

public struct AnyMedia {
    let localIdentifier: String

    public let value: Any

    init<T: MediaProtocol>(_ media: T) {
        localIdentifier = media.identifier.localIdentifier
        value = media
    }
}
