//
//  LivePhotos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Foundation
import Photos

@available(iOS 9.1, OSX 10.11, tvOS 9, *)
public struct LivePhotos {
    public static var all: [LivePhoto] {
        let options = PHFetchOptions()
        let predicate = NSPredicate(format: "mediaType = %d && (mediaSubtypes & %d) != 0", MediaType.image.rawValue, MediaSubtype.photoLive.rawValue)
        options.predicate = predicate
        let result = PHAsset.fetchAssets(with: options)

        var livePhotos: [LivePhoto] = []
        result.enumerateObjects { asset, _, _ in
            let livePhoto = LivePhoto(phAsset: asset)
            livePhotos.append(livePhoto)
        }
        return livePhotos
    }
}
