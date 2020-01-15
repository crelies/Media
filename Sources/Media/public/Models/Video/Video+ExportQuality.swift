//
//  Video+ExportQuality.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

extension Video {
    /// Available qualities for `Video` exports
    ///
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
    }
}

extension Video.ExportQuality: AVAssetExportPresetProvider {
    /// Computes the `AVAssetExportPreset` of the receiver
    /// Returns nil if the export preset is not available in the current
    /// os version (< iOS 11, tvOS 11, < macOS 10.13)
    ///
    var avAssetExportPreset: String? {
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
            if #available(iOS 11.0, tvOS 11.0, *) {
                return AVAssetExportPresetHEVC1920x1080
            } else {
                return nil
            }
        case .hevc3840x2160:
            if #available(iOS 11.0, tvOS 11.0, *) {
                return AVAssetExportPresetHEVC3840x2160
            } else {
                return nil
            }
        }
    }
}
