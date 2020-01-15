//
//  LivePhotos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

public struct LivePhotos {
    /// All live photos in the photo library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaSubtypes([.live])],
                 sort: [Sort(key: .creationDate, ascending: false)])
    public static var all: [LivePhoto]
}
