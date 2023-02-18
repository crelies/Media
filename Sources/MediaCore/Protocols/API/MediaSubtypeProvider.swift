//
//  MediaSubtypeProvider.swift
//  Media
//
//  Created by Christian Elies on 04.12.19.
//

import Photos

/// Requirements for types
/// representing media subtypes
///
public protocol MediaSubtypeProvider {
    /// `PHAssetMediaSubtype` representation of the receiver
    var mediaSubtype: MediaSubtype? { get }
}
