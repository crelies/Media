//
//  VideoError.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

/// Errors thrown during `Video` related operations
///
public enum VideoError: Error {
    /// Thrown if the given export preset is not supported for the current os version
    case unsupportedExportPreset
    /// Thrown if the file type of the output URL is not supported by the export session
    case unsupportedFileType
}
