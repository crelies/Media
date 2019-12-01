//
//  MediaPickerValue.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI)
import Photos

@available(iOS 13, OSX 10.15, *)
enum MediaPickerValue {
    case tookMedia(url: URL)
    case selectedMedia(phAsset: PHAsset)
}
#endif
