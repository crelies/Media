//
//  CameraError.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if !os(tvOS)
public enum CameraError: Error {
    case noCameraAvailable
}
#endif
