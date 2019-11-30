//
//  VideoSubtype.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

public enum VideoSubtype: CaseIterable {
    case streamed
    case highFrameRate
    case timelapse
}

extension VideoSubtype {
    public var mediaSubtype: MediaSubtype {
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
