//
//  PHAsset+anyMedia.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

extension PHAsset {
    var anyMedia: AnyMedia? {
        var anyMedia: AnyMedia?

        switch mediaType {
        case .audio:
            let audio = Audio(phAsset: self)
            anyMedia = AnyMedia(audio)
        case .image:
            switch mediaSubtypes {
            case [.photoLive]:
                let livePhoto = LivePhoto(phAsset: self)
                anyMedia = AnyMedia(livePhoto)
            default:
                let photo = Photo(phAsset: self)
                anyMedia = AnyMedia(photo)
            }
        case .video:
            let video = Video(phAsset: self)
            anyMedia = AnyMedia(video)
        case .unknown: ()
        @unknown default: ()
        }

        return anyMedia
    }
}
