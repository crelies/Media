//
//  Video+FileType.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

extension Video {
    public enum FileType {
        case mov
        case mp4
        case m4v
    }
}

extension Video.FileType {
    var pathExtension: String { String(describing: self) }

    var avFileType: AVFileType {
        switch self {
        case .mov:
            return AVFileType.mov
        case .mp4:
            return AVFileType.mp4
        case .m4v:
            return AVFileType.m4v
        }
    }
}
