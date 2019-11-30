//
//  LivePhotos.swift
//  
//
//  Created by Christian Elies on 22.11.19.
//

import Photos

@available(iOS 9, OSX 10.11, *)
public struct LivePhotos {
    public static var all: [LivePhoto] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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
