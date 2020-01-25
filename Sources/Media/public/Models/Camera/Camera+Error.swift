//
//  Camera+Error.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

@available(iOS 13, *)
@available(tvOS, unavailable)
extension Camera {
    /// Errors thrown during camera view creation
    ///
    public enum Error: Swift.Error {
        case noCameraAvailable
    }
}
