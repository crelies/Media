//
//  LazyAudio.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// <#Description#>
public final class LazyAudio {
    /// <#Description#>
    public enum Error: Swift.Error {
        ///
        case notFound
    }

    /// <#Description#>
    public let identifier: Media.Identifier<Audio>

    init(identifier: Media.Identifier<Audio>) {
        self.identifier = identifier
    }

    init?(audio: Audio) {
        guard let identifier = audio.identifier else {
            return nil
        }
        self.identifier = identifier
    }

    /// <#Description#>
    ///
    /// - Throws: <#description#>
    /// - Returns: <#description#>
    public func audio() throws -> Audio {
        guard let audio = try Audio.with(identifier: identifier) else {
            throw Error.notFound
        }

        return audio
    }
}
