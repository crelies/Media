//
//  CustomPatternMatching.swift
//  MediaCore
//
//  Created by Christian Elies on 29.11.19.
//  Hint: https://www.swiftbysundell.com/articles/defining-custom-patterns-in-swift/
//

// overload switch pattern matching
func ~=<T>(lhs: Pattern<T>, rhs: T) -> Bool {
    lhs.closure(rhs)
}

// overload key path pattern matching
func ~=<T>(lhs: KeyPath<T, Bool>, rhs: T) -> Bool {
    rhs[keyPath: lhs]
}
