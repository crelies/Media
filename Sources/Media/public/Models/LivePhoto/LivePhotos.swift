//
//  LivePhotos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

// TODO: osx 10.13
@available(macOS 10.15, *)
public struct LivePhotos {
    /// All live photos in the photo library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaType(.image), .mediaSubtypes([.photoLive])],
                 sortDescriptors: [NSSortDescriptor(key: "creationDate", ascending: false)])
    public static var all: [LivePhoto]
}
