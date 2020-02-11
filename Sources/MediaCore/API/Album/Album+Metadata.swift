//
//  Album+Metadata.swift
//  
//
//  Created by Christian Elies on 25.01.20.
//

import Photos

extension Album {
    /// Type representing metadata of an album
    ///
    public struct Metadata {
        /// The type of the asset collection, such as an album or a moment.
        public let assetCollectionType: PHAssetCollectionType

        /// The subtype of the asset collection.
        public let assetCollectionSubtype: PHAssetCollectionSubtype

        /// The estimated number of assets in the asset collection.
        public let estimatedAssetCount: Int

        /// The earliest creation date among all assets in the asset collection.
        public let startDate: Date?

        /// The latest creation date among all assets in the asset collection.
        public let endDate: Date?

        /// A location representing those of all assets in the collection.
        public let approximateLocation: CLLocation?

        /// The names of locations grouped by the collection (an array of NSString objects).
        public let localizedLocationNames: [String]
    }
}

extension Album.Metadata {
    init(phAssetCollection: PHAssetCollection) {
        assetCollectionType = phAssetCollection.assetCollectionType
        assetCollectionSubtype = phAssetCollection.assetCollectionSubtype
        estimatedAssetCount = phAssetCollection.estimatedAssetCount
        startDate = phAssetCollection.startDate
        endDate = phAssetCollection.endDate
        approximateLocation = phAssetCollection.approximateLocation
        localizedLocationNames = phAssetCollection.localizedLocationNames
    }
}
