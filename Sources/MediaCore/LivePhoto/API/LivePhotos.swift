//
//  LivePhotos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

/// Wrapper for easily fetching all live photos
/// from the photo library
///
public struct LivePhotos {
    /// All live photos in the photo library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(filter: [.mediaSubtypes([.live])],
                 sort: [Media.Sort(key: .creationDate, ascending: false)])
    public static var all: [LivePhoto]
}
