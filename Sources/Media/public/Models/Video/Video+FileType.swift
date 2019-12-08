//
//  Video+FileType.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

extension Video {
    /// Represents the available `Video` file types
    ///
    public enum FileType: CaseIterable {
        case mov
        case mp4
        case m4v
    }
}

extension Video.FileType: PathExtensionsProvider {
    /// Computes the path extension of the receiver
    ///
    public var pathExtensions: [String] { [String(describing: self)] }
}

extension Video.FileType {
    /// Computes the `AVFileType` representation of the receiver
    ///
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
