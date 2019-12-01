//
//  PhotoError.swift
//  
//
//  Created by Christian Elies on 23.11.19.
//

public enum PhotoError: Error {
    case missingFullSizeImageURL
    case missingPathExtension
    case unsupportedPathExtension
}
