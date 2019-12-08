//
//  Photo+FileType.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import AVFoundation

@available(iOS 11, macOS 10.11, tvOS 11, *)
extension Photo {
    /// Specifies the different file types for `Photo`s
    ///
    public enum FileType: CaseIterable {
        case avci
        case heic
        case heif
        case jpg
        case tif
    }
}

@available(iOS 11, macOS 10.11, tvOS 11, *)
extension Photo.FileType: PathExtensionsProvider {
    /// Computes the path extensions for the receiver
    ///
    public var pathExtensions: [String] {
        switch self {
        case .avci, .heic, .heif:
                return [String(describing: self)]
            case .jpg:
                return [String(describing: self), "jpeg"]
            case .tif:
                return ["tiff", String(describing: self)]
        }
    }

    /// Computes the `AVFileType` representation of the receiver
    ///
    var avFileType: AVFileType {
        switch self {
            case .avci:
                return AVFileType.avci
            case .heic:
                return AVFileType.heic
            case .heif:
                return AVFileType.heif
            case .jpg:
                return AVFileType.jpg
            case .tif:
                return AVFileType.tif
        }
    }
}
