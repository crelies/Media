//
//  MediaPickerValue.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && !os(tvOS)
import Photos

@available(iOS 13, macOS 10.15, *)
enum MediaPickerValue {
    case tookMedia(url: URL)
    case selectedMedia(phAsset: PHAsset)
}
#endif
