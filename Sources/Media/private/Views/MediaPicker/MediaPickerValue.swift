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
    case tookMedia(url: URL)
    case selectedMedia(phAsset: PHAsset)
}
#endif
