//
//  MockPropertyWrapperExample.swift
//  MediaTests
//
//  Created by Christian Elies on 17.12.19.
//

@testable import MediaCore

struct MockPropertyWrapperExample {
    static var localIdentifierToUse = "Test"

    @FetchAlbum(filter: [.localIdentifier(localIdentifierToUse)])
    static var testAlbum: Album?

    @FetchAsset(filter: [.localIdentifier(localIdentifierToUse)])
    static var testPhoto: Photo?
}
