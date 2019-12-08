//
//  Video+ExportOptions.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import Foundation

extension Video {
    /// Represents the options for a `Video` export
    ///
    public struct ExportOptions {
        let outputURL: MediaURL<Video>
        let quality: Video.ExportQuality

        /// Initializes video export options using the given parameters
        ///
        /// - Parameters:
        ///   - url: a destination URL
        ///   - fileType: specifies the `Video.FileType` at the given `URL`
        ///   - quality: definies the desired quality for the export
        ///
        public init(url: MediaURL<Video>, quality: Video.ExportQuality) throws {
            self.outputURL = url
            self.quality = quality
        }
    }
}
