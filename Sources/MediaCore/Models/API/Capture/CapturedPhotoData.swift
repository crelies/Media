//
//  CapturedPhotoData.swift
//  MediaCore
//
//  Created by Christian Elies on 18.01.20.
//

import Foundation

@available(iOS 10, *)
@available(tvOS, unavailable)
/// Represents the image and video portion
/// of a live photo
///
public struct CapturedPhotoData: Equatable {
    /// Data of the still image
    public let stillImageData: Data
    #if !os(macOS)
    /// Media URL to the video portion of the live photo
    public let movieURL: Media.URL<LivePhoto>
    #endif

    #if os(macOS)
    public init(stillImageData: Data) {
        self.stillImageData = stillImageData
    }
    #endif
}
