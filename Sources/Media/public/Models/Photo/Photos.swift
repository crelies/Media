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
        @FetchAssets(predicate: NSPredicate(format: "mediaType = %d", MediaType.image.rawValue),
                     sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        public static var all: [Photo]

        /// All panorama photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoPanorama.rawValue),
                     sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        public static var panorama: [Photo]

        /// All HDR photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoHDR.rawValue),
                     sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        public static var hdr: [Photo]

        /// All screenshots in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoScreenshot.rawValue),
                     sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        public static var screenshot: [Photo]

        /// All depth effect photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(predicate: NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoDepthEffect.rawValue),
                     sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
        @available(iOS 10.2, macOS 10.15, tvOS 10.1, *)
        public static var depthEffect: [Photo]
    }
}
