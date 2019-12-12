//
//  MockPHAssetCollection.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

import Photos

final class MockPHAssetCollection: PHAssetCollection {
    static var fetchResult = MockPHAssetCollectionFetchResult()
    var localIdentifierToReturn = UUID().uuidString
    var localizedTitleToReturn = "Title"
    var assetCollectionTypeToReturn: PHAssetCollectionType = .album
    var assetCollectionSubtypeToReturn: PHAssetCollectionSubtype = .albumRegular

    override var localIdentifier: String { localIdentifierToReturn }
    override var localizedTitle: String? { localizedTitleToReturn }
    override var assetCollectionType: PHAssetCollectionType { assetCollectionTypeToReturn }
    override var assetCollectionSubtype: PHAssetCollectionSubtype { assetCollectionSubtypeToReturn }

    override class func fetchAssetCollections(with type: PHAssetCollectionType,
                                              subtype: PHAssetCollectionSubtype,
                                              options: PHFetchOptions?) -> PHFetchResult<PHAssetCollection> {
        fetchResult
    }
}
