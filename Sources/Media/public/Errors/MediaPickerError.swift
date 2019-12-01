//
//  MediaPickerError.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if !os(tvOS)
public enum MediaPickerError: Error {
    case noBrowsingSourceTypeAvailable
    case unsupportedValue
}
#endif
