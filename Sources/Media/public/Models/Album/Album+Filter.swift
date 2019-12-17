//
//  AlbumFilter.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Foundation

// TODO: 10.13
@available(macOS 10.15, *)
extension Album {
    /// Represents the supported filter
    /// for filtering albums
    ///
    public enum Filter {
        case localIdentifier(_ localIdentifier: String)
        case localizedTitle(_ localizedTitle: String)
        case title(_ title: String)
        case startDate(_ startDate: Date)
        case endDate(_ endDate: Date)
        case estimatedAssetCount(_ estimatedAssetCount: Int)
    }
}

// TODO: 10.13
@available(macOS 10.15, *)
extension Album.Filter: Hashable {}

// TODO: 10.13
@available(macOS 10.15, *)
extension Album.Filter {
    var predicate: NSPredicate {
        switch self {
            case .localIdentifier(let localIdentifier):
                return NSPredicate(format: "localIdentifier = %@", localIdentifier)
            case .localizedTitle(let localizedTitle):
                return NSPredicate(format: "localizedTitle = %@", localizedTitle)
            case .title(let title):
                return NSPredicate(format: "title = %@", title)
            case .startDate(let startDate):
                return NSPredicate(format: "startDate = %@", startDate as NSDate)
            case .endDate(let endDate):
                return NSPredicate(format: "endDate = %@", endDate as NSDate)
            case .estimatedAssetCount(let estimatedAssetCount):
                return NSPredicate(format: "estimatedAssetCount = %i", estimatedAssetCount)
        }
    }
}
