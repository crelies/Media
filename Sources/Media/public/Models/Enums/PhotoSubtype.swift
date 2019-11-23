//
//  PhotoSubtype.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation

public enum PhotoSubtype: CaseIterable {
    case panorama
    case hdr
    case screenshot
    case depthEffect
}

extension PhotoSubtype {
    public var mediaSubtype: MediaSubtype? {
        switch self {
        case .panorama:
            return .photoPanorama
        case .hdr:
            return .photoHDR
        case .screenshot:
            if #available(iOS 9, *) {
                return .photoScreenshot
            } else {
                return nil
            }
        case .depthEffect:
            if #available(iOS 10.2, *) {
                return .photoDepthEffect
            } else {
                return nil
            }
        }
    }
}
