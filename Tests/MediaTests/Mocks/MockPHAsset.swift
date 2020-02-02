//
//  MockPHAsset.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPHAsset: PHAsset {
    static var fetchResult = MockPHAssetsFetchResult()

    var localIdentifierToReturn = UUID().uuidString
    var mediaTypeToReturn: PHAssetMediaType = .image
    var mediaSubtypesToReturn: PHAssetMediaSubtype = []
    var isFavoriteToReturn = false
    var contentEditingInputToReturn: PHContentEditingInput?

    override var localIdentifier: String { localIdentifierToReturn }
    override var mediaType: PHAssetMediaType { mediaTypeToReturn }
    override var mediaSubtypes: PHAssetMediaSubtype { mediaSubtypesToReturn }
    override var isFavorite: Bool { isFavoriteToReturn }

    override class func fetchAssets(with options: PHFetchOptions?) -> PHFetchResult<PHAsset> {
        fetchResult
    }

    override func requestContentEditingInput(
        with options: PHContentEditingInputRequestOptions?,
        completionHandler: @escaping (PHContentEditingInput?, [AnyHashable : Any]) -> Void) -> PHContentEditingInputRequestID {
        completionHandler(contentEditingInputToReturn, [:])
        return Int.random(in: 1...999)
    }
}
