//
//  Video+ExportDestination.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import AVFoundation

extension Video {
    public struct ExportDestination {
        public let outputURL: URL
        let outputFileType: AVFileType

        public init(url: URL, fileType: Video.FileType) throws {
            var url = url

            switch url.pathExtension {
            case \.isEmpty:
                url.appendPathExtension(fileType.pathExtension)
            case .mismatchs(fileType.pathExtension):
                throw Video.ExportDestinationError.pathExtensionMismatch
            default: ()
            }

            self.outputURL = url
            self.outputFileType = fileType.avFileType
        }
    }
}
