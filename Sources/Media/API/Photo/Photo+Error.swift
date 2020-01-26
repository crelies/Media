//
//  Photo+Error.swift
//  Media
//
//  Created by Christian Elies on 23.11.19.
//

extension Photo {
    /// Errors thrown during `Photo` related operations
    ///
    public enum Error: Swift.Error {
        /// Thrown if a CIImage instance could not be created
        case couldNotCreateCIImage
        /// Thrown if a full size image URL is missing
        case missingFullSizeImageURL
    }
}
