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
        public let outputURL: URL
        let fileType: Video.FileType
        let quality: Video.ExportQuality

        /// Initializes video export options using the given parameters
        ///
        /// - Parameters:
        ///   - url: a destination URL
        ///   - fileType: specifies the `Video.FileType` at the given `URL`
        ///   - quality: definies the desired quality for the export
        ///
        public init(url: URL, fileType: Video.FileType, quality: Video.ExportQuality) throws {
            var url = url

            switch url.pathExtension {
            case \.isEmpty:
                url.appendPathExtension(fileType.pathExtensions.first!)
            case .mismatchs(fileType.pathExtensions.first!):
                throw Video.ExportDestinationError.pathExtensionMismatch
            default: ()
            }

            self.outputURL = url
            self.fileType = fileType
            self.quality = quality
        }
    }
}
