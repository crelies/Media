//
//  Video+Subtype.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

extension Video {
    /// Subtypes describing a `Video`
    ///
    public enum Subtype: CaseIterable {
        case streamed
        case highFrameRate
        case timelapse
    }
}

extension Video.Subtype: MediaSubtypeProvider {
    /// Compute a `PHAssetMediaSubtype` from the receiver
    ///
    public var mediaSubtype: MediaSubtype? {
        switch self {
        case .streamed:
            return .videoStreamed
        case .highFrameRate:
            return .videoHighFrameRate
        case .timelapse:
            return .videoTimelapse
        }
    }
}
