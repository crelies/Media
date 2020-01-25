//
//  MediaPicker+Error.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit) && !os(tvOS)
@available(iOS 13, *)
extension MediaPicker {
    /// Errors thrown by the `MediaPicker`
    ///
    public enum Error: Swift.Error {
        /// browsing the photo library is not supported on the current device
        case noBrowsingSourceTypeAvailable
        /// picker value is not supported by the caller
        case unsupportedValue
    }
}
#endif
