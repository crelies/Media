//
//  Sort.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Foundation

/// Represents a generic sort value
/// with a key (`String RawRepresentable`) and a boolean indicating
/// ascending order
///
public struct Sort<T: RawRepresentable> where T.RawValue == String {
    let key: T
    let ascending: Bool

    /// Initializes a sort
    ///
    /// - Parameters:
    ///   - key: a `String RawPresentable`
    ///   - ascending: boolean indicating ascending or descending order
    ///
    public init(key: T, ascending: Bool) {
        self.key = key
        self.ascending = ascending
    }
}

extension Sort: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key.rawValue)
        hasher.combine(ascending)
    }
}

extension Sort: Equatable {
    public static func == (lhs: Sort<T>, rhs: Sort<T>) -> Bool {
        lhs.key.rawValue == rhs.key.rawValue && lhs.ascending == rhs.ascending
    }
}

extension Sort {
    var sortDescriptor: NSSortDescriptor { NSSortDescriptor(key: key.rawValue,
                                                            ascending: ascending) }
}
