//
//  OptionalString+compare.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

import Foundation

extension Optional where Wrapped == String {
    func compare(_ element: Self) -> ComparisonResult {
        switch (self, element) {
        case (.none, .none):
            return .orderedSame
        case (.some(let lhsValue), .some(let rhsValue)):
            return lhsValue.compare(rhsValue)
        case (.some, .none):
            return .orderedDescending
        case (.none, .some):
            return .orderedAscending
        }
    }
}
