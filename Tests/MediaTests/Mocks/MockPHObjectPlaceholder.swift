//
//  MockPHObjectPlaceholder.swift
//  Media
//
//  Created by Christian Elies on 12.12.19.
//

import Photos

@available(macOS 10.15, *)
final class MockPHObjectPlaceholder: PHObjectPlaceholder {
    var localIdentifierToReturn = UUID().uuidString

    override var localIdentifier: String { localIdentifierToReturn }
}
