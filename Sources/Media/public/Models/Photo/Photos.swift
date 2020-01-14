//
//  Photos.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

import Photos

@available(macOS 10.15, *)
extension Media {
    public struct Photos {
        /// All photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(sort: [Sort(key: .creationDate, ascending: false)])
        public static var all: [Photo]

        /// All live photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(filter: [.mediaSubtypes([.live])],
                     sort: [Sort(key: .creationDate, ascending: false)])
        public static var live: [LivePhoto]

        /// All panorama photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(filter: [.mediaSubtypes([.panorama])],
                     sort: [Sort(key: .creationDate, ascending: false)])
        public static var panorama: [Photo]

        /// All HDR photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(filter: [.mediaSubtypes([.hdr])],
                     sort: [Sort(key: .creationDate, ascending: false)])
        public static var hdr: [Photo]

        /// All screenshots in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(filter: [.mediaSubtypes([.screenshot])],
                     sort: [Sort(key: .creationDate, ascending: false)])
        public static var screenshot: [Photo]

        /// All depth effect photos in the library
        /// sorted by `creationDate descending`
        ///
        @FetchAssets(filter: [.mediaSubtypes([.depthEffect])],
                     sort: [Sort(key: .creationDate, ascending: false)])
        @available(iOS 10.2, macOS 10.15, tvOS 10.1, *)
        public static var depthEffect: [Photo]
    }
}
