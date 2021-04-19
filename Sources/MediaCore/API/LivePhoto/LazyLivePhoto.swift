//
//  LazyLivePhoto.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// Wrapper type for lazily fetching a live photo.
public final class LazyLivePhoto {
    /// Represents the errors thrown by this type.
    public enum Error: Swift.Error {
        /// Thrown if no live photo with a given identifier was found.
        case notFound
    }

    /// The identifier of the live photo.
    public let identifier: Media.Identifier<LivePhoto>

    init(identifier: Media.Identifier<LivePhoto>) {
        self.identifier = identifier
    }

    init?(livePhoto: LivePhoto) {
        guard let identifier = livePhoto.identifier else {
            return nil
        }
        self.identifier = identifier
    }

    /// Fetches the LivePhoto with the given identifier if it exists.
    ///
    /// - Throws: An error if not found.
    /// - Returns: A `LivePhoto` if found.
    public func livePhoto() throws -> LivePhoto {
        guard let livePhoto = try LivePhoto.with(identifier: identifier) else {
            throw Error.notFound
        }

        return livePhoto
    }
}
