//
//  LazyVideo.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// Wrapper type for lazily fetching a video.
public final class LazyVideo {
    /// Represents the errors thrown by this type.
    public enum Error: Swift.Error {
        /// Thrown if a video with a given identifier was not found.
        case notFound
    }

    /// The identifier of the video.
    public let identifier: Media.Identifier<Video>

    init(identifier: Media.Identifier<Video>) {
        self.identifier = identifier
    }

    init?(video: Video) {
        guard let identifier = video.identifier else {
            return nil
        }
        self.identifier = identifier
    }

    /// Fetches the Video with the given identifier if it exists.
    ///
    /// - Throws: An error if not found.
    /// - Returns: A `Video` if found.
    public func video() throws -> Video {
        guard let video = try Video.with(identifier: identifier) else {
            throw Error.notFound
        }

        return video
    }
}
