//
//  Video+ExportProgress.swift
//  MediaCore
//
//  Created by Christian Elies on 30.11.19.
//

extension Video {
    /// Represents the export progress
    ///
    public enum ExportProgress {
        /// export is completed
        case completed
        /// export is in progress, value (0.0-1.0) represents current state
        case pending(value: Float)
    }
}
