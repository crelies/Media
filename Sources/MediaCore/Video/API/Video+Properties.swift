//
//  Video+Properties.swift
//  MediaCore
//
//  Created by Christian Elies on 25.01.20.
//

import AVFoundation

extension Video {
    /// Properties of the underlying asset
    /// which have to be fetched
    ///
    public struct Properties {
        /// Location where the `Video` was taken
        public private(set) var location: String?
        /// Vendor of the device which took the `Video`
        public private(set) var make: String?
        /// Model of the device which took the `Video`
        public private(set) var model: String?
        /// Software of the device which took the `Video`
        public private(set) var software: String?
        /// Creation date of the `Video`
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
