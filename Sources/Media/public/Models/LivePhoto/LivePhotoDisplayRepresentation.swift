//
//  LivePhotoDisplayRepresentation.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

import Photos

extension LivePhoto {
    public struct DisplayRepresentation {
        public let quality: LivePhoto.Quality
        public let livePhoto: PHLivePhoto
    }
}
