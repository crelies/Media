//
//  LazyAudio.swift
//  MediaCore
//
//  Created by Christian Elies on 20.02.21.
//

/// Wrapper type for lazily fetching an audio.
public final class LazyAudio {
    /// Represents the errors thrown by this type.
    public enum Error: Swift.Error {
        /// Thrown if no audio with a given identifier was found.
        case notFound
    }

    /// The identifier of the audio.
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

    /// Fetches the audio with the given identifier if it exists.
    ///
    /// - Throws: An error if not found.
    /// - Returns: An `Audio` if found.
    public func audio() throws -> Audio {
        guard let audio = try Audio.with(identifier: identifier) else {
            throw Error.notFound
        }

        return audio
    }
}
