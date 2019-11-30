//
//  Video+ExportProgress.swift
//  
//
//  Created by Christian Elies on 30.11.19.
//

extension Video {
    public enum ExportProgress {
        case completed
        case pending(value: Float)
    }
}
