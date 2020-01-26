//
//  MediaSubtypeProvider.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

/// Requirements for types
/// representing media subtypes
///
public protocol MediaSubtypeProvider {
    var mediaSubtype: MediaSubtype? { get }
}
