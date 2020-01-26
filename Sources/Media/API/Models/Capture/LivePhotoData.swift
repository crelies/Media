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
public struct LivePhotoData {
    public let stillImageData: Data
    public let movieURL: Media.URL<LivePhoto>
}
