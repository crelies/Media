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
        case mobile3GPP
        case mobile3GPP2
    }
}

extension Video.FileType {
    var pathExtension: String {
        switch self {
        case .mov:
            return "mov"
        case .mp4:
            return "mp4"
        case .m4v:
            return "m4v"
        case .mobile3GPP:
            return "3gpp"
        case .mobile3GPP2:
            return "3gp2"
        }
    }

    var avFileType: AVFileType {
        switch self {
        case .mov:
            return AVFileType.mov
        case .mp4:
            return AVFileType.mp4
        case .m4v:
            return AVFileType.m4v
        case .mobile3GPP:
            return AVFileType.mobile3GPP
        case .mobile3GPP2:
            return AVFileType.mobile3GPP2
        }
    }
}
