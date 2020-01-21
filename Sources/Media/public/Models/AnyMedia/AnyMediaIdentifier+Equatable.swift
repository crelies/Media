//
//  AnyMediaIdentifier+Equatable.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

extension AnyMediaIdentifier: Equatable {
    public static func ==(lhs: AnyMediaIdentifier, rhs: AnyMediaIdentifier) -> Bool {
        lhs.localIdentifier == rhs.localIdentifier
    }
}
