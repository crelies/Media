//
//  Video+ExportOptions.swift
//  MediaCore
//
//  Created by Christian Elies on 29.11.19.
//

import Photos

#if os(iOS) || os(tvOS)
public typealias VideoExportQualityType = Video.ExportQuality
#elseif os(macOS)
public typealias VideoExportQualityType = Video.ExportQualityMac
#endif

extension Video {
    /// Represents the options for a `Video` export
    ///
    public struct ExportOptions {
        let outputURL: Media.URL<Video>
        let quality: VideoExportQualityType
        let deliveryMode: PHVideoRequestOptionsDeliveryMode

        /// Initializes video export options using the given parameters
        ///
        /// - Parameters:
        ///   - url: a destination URL
        ///   - fileType: specifies the `Video.FileType` at the given `URL`
        ///   - quality: definies the desired quality for the export
        ///
        public init(url: Media.URL<Video>, quality: VideoExportQualityType, deliveryMode: PHVideoRequestOptionsDeliveryMode = .automatic) {
            self.outputURL = url
            self.quality = quality
            self.deliveryMode = deliveryMode
        }
    }
}
