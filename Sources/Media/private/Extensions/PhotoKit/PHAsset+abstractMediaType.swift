//
//  PHAsset+abstractMediaType.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

extension PHAsset {
    var abstractMediaType: MediaProtocol.Type? {
        var type: MediaProtocol.Type?

        switch mediaType {
        case .audio:
            type = Audio.self
        case .image:
            switch mediaSubtypes {
            case [.photoLive]:
                type = LivePhoto.self
            default:
                type = Photo.self
            }
        case .video:
            type = Video.self
        case .unknown: ()
        @unknown default: ()
        }

        return type
    }
}
