//
//  Video+ExportQuality.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

extension Video {
    public enum ExportQuality {
        case low
        case medium
        case highest
        case q640x480
        case q960x540
        case q1280x720
        case q1920x1080
        case q3840x2160
        case hevc1920x1080
        case hevc3840x2160

        var avAssetExportPreset: String {
            switch self {
            case .low:
                return AVAssetExportPresetLowQuality
            case .medium:
                return AVAssetExportPresetMediumQuality
            case .highest:
                return AVAssetExportPresetHighestQuality
            case .q640x480:
                return AVAssetExportPreset640x480
            case .q960x540:
                return AVAssetExportPreset960x540
            case .q1280x720:
                return AVAssetExportPreset1280x720
            case .q1920x1080:
                return AVAssetExportPreset1920x1080
            case .q3840x2160:
                return AVAssetExportPreset3840x2160
            case .hevc1920x1080:
                return AVAssetExportPresetHEVC1920x1080
            case .hevc3840x2160:
                return AVAssetExportPresetHEVC3840x2160
            }
        }
    }
}
