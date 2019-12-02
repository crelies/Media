//
//  Video+ExportDestinationError.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

extension Video {
    /// Errors thrown during video export
    ///
    public enum ExportDestinationError: Error {
        case pathExtensionMismatch
    }
}
