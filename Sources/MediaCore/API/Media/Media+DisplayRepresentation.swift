//
//  Media+DisplayRepresentation.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

extension Media {
    /// A display representation type with a generic value and
    /// a specific quality enumeration value
    /// Used for `LivePhoto`s and `Photo`s which can be returned
    /// in `low` and `high` quality
    ///
    public struct DisplayRepresentation<T> {
        public let value: T
        public let quality: Media.Quality
    }
}
