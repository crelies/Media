//
//  LazyVideo.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// <#Description#>
public final class LazyVideo {
    /// <#Description#>
    public enum Error: Swift.Error {
        ///
        case notFound
    }

    /// <#Description#>
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

    /// <#Description#>
    ///
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    public func video() throws -> Video {
        guard let video = try Video.with(identifier: identifier) else {
            throw Error.notFound
        }

        return video
    }
}
