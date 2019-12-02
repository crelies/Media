//
//  MediaPickerError.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

@available(tvOS, unavailable)
/// Errors thrown by the `MediaPicker`
///
public enum MediaPickerError: Error {
    /// browsing the photo library is not supported on the current device
    case noBrowsingSourceTypeAvailable
    /// picker value is not supported by the caller
    case unsupportedValue
}
