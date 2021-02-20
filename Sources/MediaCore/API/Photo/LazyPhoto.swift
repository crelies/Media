//
//  LazyPhoto.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// <#Description#>
public final class LazyPhoto {
    /// <#Description#>
    public enum Error: Swift.Error {
        ///
        case notFound
    }

    /// <#Description#>
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

    /// <#Description#>
    ///
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    public func photo() throws -> Photo {
        guard let photo = try Photo.with(identifier: identifier) else {
            throw Error.notFound
        }

        return photo
    }
}
