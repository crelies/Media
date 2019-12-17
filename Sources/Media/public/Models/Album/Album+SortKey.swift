//
//  AlbumSortKey.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

// TODO: 10.13
@available(macOS 10.15, *)
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
