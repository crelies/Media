//
//  AlbumSortKey.swift
//  MediaCore
//
//  Created by Christian Elies on 04.12.19.
//

extension Album {
    /// Represents the supported keys
    /// for sorting albums
    ///
    public enum SortKey: String {
        case localIdentifier
        case localizedTitle
        case title
        case startDate
        case endDate
        case estimatedAssetCount
    }
}
