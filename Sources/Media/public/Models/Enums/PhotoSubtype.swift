//
//  PhotoSubtype.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

/// Subtypes describing a `Photo`
///
public enum PhotoSubtype: CaseIterable {
    case panorama
    case hdr
    case screenshot
    case depthEffect
}

extension PhotoSubtype {
    /// Compute a `PHAssetMediaSubtype` from the receiver
    ///
    public var mediaSubtype: MediaSubtype? {
        switch self {
        case .panorama:
            return .photoPanorama
        case .hdr:
            return .photoHDR
        case .screenshot:
            return .photoScreenshot
        case .depthEffect:
            if #available(iOS 10.2, macOS 10.13, tvOS 10.1, *) {
                return .photoDepthEffect
            } else {
                return nil
            }
        }
    }
}
