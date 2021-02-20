//
//  LazyLivePhoto.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// <#Description#>
public final class LazyLivePhoto {
    /// <#Description#>
    public enum Error: Swift.Error {
        ///
        case notFound
    }

    /// <#Description#>
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

    /// <#Description#>
    ///
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    public func livePhoto() throws -> LivePhoto {
        guard let livePhoto = try LivePhoto.with(identifier: identifier) else {
            throw Error.notFound
        }

        return livePhoto
    }
}
