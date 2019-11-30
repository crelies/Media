//
//  LivePhotoDisplayRepresentation.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

import Photos

@available(iOS 9, *)
extension LivePhoto {
    public struct DisplayRepresentation {
        public let quality: Media.Quality
        public let livePhoto: PHLivePhoto
    }
}
