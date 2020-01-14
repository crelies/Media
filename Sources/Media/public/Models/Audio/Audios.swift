//
//  Audios.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

@available(macOS 10.15, *)
public struct Audios {
    /// All audios in the photo library
    /// sorted by `creationDate descending`
    ///
    @FetchAssets(sort: [Sort(key: .creationDate, ascending: false)])
    public static var all: [Audio]
}
