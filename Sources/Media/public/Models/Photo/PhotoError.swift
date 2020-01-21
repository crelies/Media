//
//  PhotoError.swift
//  
//
//  Created by Christian Elies on 23.11.19.
//

/// Errors thrown during `Photo` related operations
///
public enum PhotoError: Error {
    case couldNotCreateCIImage
    case missingFullSizeImageURL
}
