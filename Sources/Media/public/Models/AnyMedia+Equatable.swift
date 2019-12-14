//
//  AnyMedia+Equatable.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

extension AnyMedia: Equatable {
    public static func ==(lhs: AnyMedia, rhs: AnyMedia) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
