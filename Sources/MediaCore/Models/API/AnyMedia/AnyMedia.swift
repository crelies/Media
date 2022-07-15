//
//  AnyMedia.swift
//  Media
//
//  Created by Christian Elies on 04.12.19.
//

/// Type erased wrapper for all media objects
/// (audio, (live) photo or video)
///
public struct AnyMedia {
    /// Identifier of the receiver
    public let identifier: AnyMedia.Identifier
    /// Type erased value
    public let value: Any

    init?<T: MediaProtocol>(_ media: T) {
        guard let identifier = media.identifier else { return nil }
        self.identifier = AnyMedia.Identifier(identifier)
        value = media
    }
}
