//
//  Video+ExportDestinationError.swift
//  
//
//  Created by Christian Elies on 29.11.19.
//

import Foundation

extension Video {
    public enum ExportDestinationError: Error {
        case pathExtensionMismatch
    }
}
