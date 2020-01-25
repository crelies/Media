//
//  Camera+Error.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
@available(iOS 13, *)
extension Camera {
    /// Errors thrown during camera view creation
    ///
    public enum Error: Swift.Error {
        case noCameraAvailable
    }
}
#endif
