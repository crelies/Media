//
//  LivePhoto+Subtype.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

extension LivePhoto {
    /// Convenience type representing the
    /// available subtypes of a live photo
    /// used by this Swift package
    ///
    public enum Subtype {
        case live
    }
}

extension LivePhoto.Subtype: MediaSubtypeProvider {
    /// Returns the related `PHAssetMediaSubtype`
    /// of the receiving subtype
    ///
    public var mediaSubtype: MediaSubtype? { .photoLive }
}
