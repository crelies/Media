//
//  AnyMedia+Identifier+Equatable.swift
//  Media
//
//  Created by Christian Elies on 14.12.19.
//

extension AnyMedia.Identifier: Equatable {
    public static func ==(lhs: AnyMedia.Identifier, rhs: AnyMedia.Identifier) -> Bool {
        lhs.localIdentifier == rhs.localIdentifier
    }
}
