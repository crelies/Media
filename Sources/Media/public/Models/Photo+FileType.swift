//
//  Photo+FileType.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import AVFoundation

extension Photo {
    public enum FileType: CaseIterable {
        case avci
        case heic
        case heif
        case jpg
        case tif
    }
}

extension Photo.FileType {
    var pathExtensions: [String] {
        switch self {
            case .avci:
                return ["avci"]
            case .heic:
                return ["heic"]
            case .heif:
                return ["heif"]
            case .jpg:
                return ["jpg", "jpeg"]
            case .tif:
                return ["tiff", "tif"]
        }
    }

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
