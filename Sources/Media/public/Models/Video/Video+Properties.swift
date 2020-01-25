//
//  Video+Properties.swift
//  
//
//  Created by Christian Elies on 25.01.20.
//

import AVFoundation

extension Video {
    public struct Properties {
        public private(set) var location: String?
        public private(set) var make: String?
        public private(set) var model: String?
        public private(set) var software: String?
        public private(set) var creationDate: Date?
    }
}

extension Video.Properties {
    init(metadata: [AVMetadataItem]) {
        for item in metadata {
            switch item.commonKey {
            case .commonKeyLocation?:
                location = item.stringValue
            case .commonKeyMake?:
                make = item.stringValue
            case .commonKeyModel?:
                model = item.stringValue
            case .commonKeySoftware?:
                software = item.stringValue
            case .commonKeyCreationDate?:
                creationDate = item.dateValue
            default: ()
            }
        }
    }
}
