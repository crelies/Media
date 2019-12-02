//
//  Photos.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
extension Media {
    public struct Photos {
        /// All photos in the library
        /// sorted by `creationDate descending`
        ///
        public static var all: [Photo] {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let predicate = NSPredicate(format: "mediaType = %d", MediaType.image.rawValue)
            options.predicate = predicate
            let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
            return photos
        }

        /// All panorama photos in the library
        /// sorted by `creationDate descending`
        ///
        public static var panorama: [Photo] {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoPanorama.rawValue)
            options.predicate = predicate
            let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
            return photos
        }

        /// All HDR photos in the library
        /// sorted by `creationDate descending`
        ///
        public static var hdr: [Photo] {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoHDR.rawValue)
            options.predicate = predicate
            let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
            return photos
        }

        /// All screenshots in the library
        /// sorted by `creationDate descending`
        ///
        public static var screenshot: [Photo] {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoScreenshot.rawValue)
            options.predicate = predicate
            let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
            return photos
        }

        /// All depth effect photos in the library
        /// sorted by `creationDate descending`
        ///
        @available(iOS 10.2, macOS 10.15, tvOS 10.1, *)
        public static var depthEffect: [Photo] {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoDepthEffect.rawValue)
            options.predicate = predicate
            let photos = PHAssetFetcher.fetchAssets(options: options) as [Photo]
            return photos
        }
    }
}
