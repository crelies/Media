//
//  AlbumFilter.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Foundation

public enum AlbumFilter {
    case localIdentifier(_ localIdentifier: String)
    case localizedTitle(_ localizedTitle: String)
    case title(_ title: String)
    case startDate(_ startDate: Date)
    case endDate(_ endDate: Date)
    case estimatedAssetCount(_ estimatedAssetCount: Int)
}

extension AlbumFilter: Hashable {}

extension AlbumFilter {
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
