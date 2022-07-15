//
//  LivePhotoData.swift
//  
//
//  Created by Christian Elies on 18.01.20.
//

import Foundation

@available(iOS 10, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
/// Represents the image and video portion
/// of a live photo
///
public struct LivePhotoData: Equatable {
    /// Data of the still image
    public let stillImageData: Data
    /// Media URL to the video portion of the live photo
    public let movieURL: Media.URL<LivePhoto>
}
