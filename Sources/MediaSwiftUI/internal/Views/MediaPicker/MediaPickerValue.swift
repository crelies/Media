//
//  MediaPickerValue.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI)
import Photos

@available(iOS 13, macOS 10.15, *)
@available(tvOS, unavailable)
enum MediaPickerValue {
    case tookPhoto(url: URL)
    case tookVideo(url: URL)
    case selectedMedia(phAsset: PHAsset)
    case selectedLivePhoto(_ livePhoto: PHLivePhoto, phAsset: PHAsset)
}
#endif
