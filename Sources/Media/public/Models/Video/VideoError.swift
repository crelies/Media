//
//  VideoError.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

extension Video {
    /// Errors thrown during `Video` related operations
    ///
    public enum Error: Swift.Error {
        /// AVAsset is missing in the response
        case noAVAssetInResponse
        /// Thrown if the given export preset is not supported for the current os version
        case unsupportedExportPreset
        /// Thrown if the file type of the output URL is not supported by the export session
        case unsupportedFileType
    }
}
