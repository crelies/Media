//
//  AnyMedia+Identifier.swift
//  Media
//
//  Created by Christian Elies on 08.12.19.
//

extension AnyMedia {
    /// Identifier type for any media objects
    /// (audio, (live) photo or video)
    ///
    public struct Identifier {
        /// Local identifier of the underlying
        ///  `PHAsset` instance
        ///
        public let localIdentifier: String

        init<T: MediaProtocol>(_ identifier: Media.Identifier<T>) {
            localIdentifier = identifier.localIdentifier
        }
    }
}
