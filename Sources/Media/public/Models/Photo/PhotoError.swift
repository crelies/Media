//
//  PhotoError.swift
//  
//
//  Created by Christian Elies on 23.11.19.
//

extension Photo {
    /// Errors thrown during `Photo` related operations
    ///
    public enum Error: Swift.Error {
        case couldNotCreateCIImage
        case missingFullSizeImageURL
    }
}
