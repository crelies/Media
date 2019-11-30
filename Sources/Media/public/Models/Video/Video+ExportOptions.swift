//
//  Video+ExportOptions.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import Foundation

extension Video {
    public struct ExportOptions {
        public let outputURL: URL
        let fileType: Video.FileType
        let quality: Video.ExportQuality

        public init(url: URL, fileType: Video.FileType, quality: Video.ExportQuality) throws {
            var url = url

            switch url.pathExtension {
            case \.isEmpty:
                url.appendPathExtension(fileType.pathExtension)
            case .mismatchs(fileType.pathExtension):
                throw Video.ExportDestinationError.pathExtensionMismatch
            default: ()
            }

            self.outputURL = url
            self.fileType = fileType
            self.quality = quality
        }
    }
}
