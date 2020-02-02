//
//  MockPHContentEditingInput.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

import Photos

final class MockPHContentEditingInput: PHContentEditingInput {
    var fullSizeImageURLToReturn: URL?

    override var fullSizeImageURL: URL? { fullSizeImageURLToReturn }
}
