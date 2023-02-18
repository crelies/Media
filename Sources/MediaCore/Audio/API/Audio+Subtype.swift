//
//  Audio+Subtype.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

import Photos

extension Audio {
    /// Type representing subtypes of an `Audio`
    public enum Subtype {}
}

extension Audio.Subtype: MediaSubtypeProvider {
    /// Returns the `PHAssetMediaSubtype` of the receiver
    public var mediaSubtype: MediaSubtype? { nil }
}
