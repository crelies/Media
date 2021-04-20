//
//  LazyPhoto.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// Wrapper type for lazily fetching a photo.
public final class LazyPhoto {
    /// Represents the errors thrown by this type.
    public enum Error: Swift.Error {
        /// Thrown if no photo with a given identifier was found.
        case notFound
    }

    /// The identifier of the photo.
    public let identifier: Media.Identifier<Photo>

    init(identifier: Media.Identifier<Photo>) {
        self.identifier = identifier
    }

    init?(photo: Photo) {
        guard let identifier = photo.identifier else {
            return nil
        }
        self.identifier = identifier
    }

    /// Fetches the Photo with the given identifier if it exists.
    ///
    /// - Throws: An error if not found.
    /// - Returns: A `Photo` if found.
    public func photo() throws -> Photo {
        guard let photo = try Photo.with(identifier: identifier) else {
            throw Error.notFound
        }

        return photo
    }
}
