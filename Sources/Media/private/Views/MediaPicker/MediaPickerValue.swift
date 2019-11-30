//
//  MediaPickerValue.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI)
import Foundation

@available(iOS 13, OSX 10.15, *)
enum MediaPickerValue {
    case tookPhoto(url: URL)
    case tookLivePhoto(url: URL)
    case tookVideo(url: URL)
    case selectedPhoto(_ photo: Photo)
    case selectedLivePhoto(_ livePhoto: LivePhoto)
    case selectedVideo(_ video: Video)
}
#endif
