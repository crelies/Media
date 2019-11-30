//
//  Video+ExportQualityMac.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

// TODO: currently not used
#if !targetEnvironment(macCatalyst)
@available(OSX 10.8, *)
extension Video {
    public enum ExportQualityMac {
        case cellular
        case ipod
        case sd480p
        case appleTV
        case wifi
        case hd720p
        case hd1080p
        // 10.15
//        case proRes422LPCM
    }
}

@available(OSX 10.8, *)
extension Video.ExportQualityMac {
    var avAssetExportPreset: String {
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
//            case .proRes422LPCM:
//                return AVAssetExportPresetAppleProRes422LPCM
        }
    }
}
#endif
