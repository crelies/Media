//
//  Media+SortKey.swift
//  Media
//
//  Created by Christian Elies on 04.12.19.
//

extension Media {
    /// Represents the supported keys
    /// for sorting media (`Audio`, `LivePhoto`, `Photo` or `Video`)
    ///
    public enum SortKey: String {
        case localIdentifier
        case creationDate
        case modificationDate
        case mediaType
        case mediaSubtypes
        case duration
        case pixelWidth
        case pixelHeight
        case isFavorite
        case isHidden
        case burstIdentifier
    }
}
