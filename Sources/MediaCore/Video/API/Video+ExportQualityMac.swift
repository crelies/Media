//
//  Video+ExportQualityMac.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

#if os(macOS)
extension Video {
    /// Available qualities for `Video` exports
    /// on the mac
    ///
    public enum ExportQualityMac {
        case cellular
        case ipod
        case sd480p
        case appleTV
        case wifi
        case hd720p
        case hd1080p
        case proRes422LPCM
    }
}

extension Video.ExportQualityMac: AVAssetExportPresetProvider {
    /// Computes the `AVAssetExportPreset` of the receiver
    /// Returns nil if the export preset is not available in the current
    /// os version (< iOS 11, tvOS 11, < macOS 10.13)
    ///
    var avAssetExportPreset: String? {
        switch self {
            case .cellular:
                return AVAssetExportPresetAppleM4VCellular
            case .ipod:
                return AVAssetExportPresetAppleM4ViPod
            case .sd480p:
                return AVAssetExportPresetAppleM4V480pSD
            case .appleTV:
                return AVAssetExportPresetAppleM4VAppleTV
            case .wifi:
                return AVAssetExportPresetAppleM4VWiFi
            case .hd720p:
                return AVAssetExportPresetAppleM4V720pHD
            case .hd1080p:
                return AVAssetExportPresetAppleM4V1080pHD
            case .proRes422LPCM:
                return AVAssetExportPresetAppleProRes422LPCM
        }
    }
}
#endif
