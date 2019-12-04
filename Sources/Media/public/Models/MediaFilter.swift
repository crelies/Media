//
//  MediaFilter.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Foundation

public enum MediaFilter {
    case localIdentifier(_ localIdentifier: String)
    case creationDate(_ creationDate: Date)
    case modificationDate(_ modificationDate: Date)
    // TODO: constraint media type
    case mediaType(_ mediaType: MediaType)
    // TODO: constraint media sub type
    case mediaSubtypes(_ subtypes: [MediaSubtype])
    case duration(_ duration: TimeInterval)
    case pixelWidth(_ pixelWidth: Int)
    case pixelHeight(_ pixelHeight: Int)
    case isFavorite(_ isFavorite: Bool)
    case isHidden(_ isHidden: Bool)
    case burstIdentifier(_ burstIdentifier: String)
}

extension MediaFilter: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
            case .localIdentifier(let localIdentifier):
                hasher.combine(localIdentifier)
            case .creationDate(let creationDate):
                hasher.combine(creationDate)
            case .modificationDate(let modificationDate):
                hasher.combine(modificationDate)
            case .mediaType(let mediaType):
                hasher.combine(mediaType)
            case .mediaSubtypes(let subtypes):
                hasher.combine(subtypes)
            case .duration(let duration):
                hasher.combine(duration)
            case .pixelWidth(let pixelWidth):
                hasher.combine(pixelWidth)
            case .pixelHeight(let pixelHeight):
                hasher.combine(pixelHeight)
            case .isFavorite(let isFavorite):
                hasher.combine(isFavorite)
            case .isHidden(let isHidden):
                hasher.combine(isHidden)
            case .burstIdentifier(let burstIdentifier):
                hasher.combine(burstIdentifier)
        }
    }
}

extension MediaFilter {
    var predicate: NSPredicate {
        switch self {
            case .localIdentifier(let localIdentifier):
                return NSPredicate(format: "localIdentifier = %@", localIdentifier)
            case .creationDate(let creationDate):
                return NSPredicate(format: "creationDate = %@", creationDate as NSDate)
            case .modificationDate(let modificationDate):
                return NSPredicate(format: "modificationDate = %@", modificationDate as NSDate)
            case .mediaType(let mediaType):
                return NSPredicate(format: "mediaType = %d", mediaType.rawValue)
            case .mediaSubtypes(let subtypes):
                let predicateFormatStatements = subtypes.map { _ in "(mediaSubtypes & %d) != 0" }
                let predicateFormatString = predicateFormatStatements.joined(separator: " || ")
                let subtypeRawValues = subtypes.map { $0.rawValue }
                return NSPredicate(format: predicateFormatString, subtypeRawValues)
            case .duration(let duration):
                return NSPredicate(format: "duration = %d", duration)
            case .pixelWidth(let pixelWidth):
                return NSPredicate(format: "pixelWidth = %i", pixelWidth)
            case .pixelHeight(let pixelHeight):
                return NSPredicate(format: "pixelHeight = %i", pixelHeight)
            case .isFavorite(let isFavorite):
                return NSPredicate(format: "isFavorite = %@", NSNumber(booleanLiteral: isFavorite))
            case .isHidden(let isHidden):
                return NSPredicate(format: "isHidden = %@", NSNumber(booleanLiteral: isHidden))
            case .burstIdentifier(let burstIdentifier):
                return NSPredicate(format: "burstIdentifier = %@", burstIdentifier)
        }
    }
}
