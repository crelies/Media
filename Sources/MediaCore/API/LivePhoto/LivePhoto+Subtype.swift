//
//  LivePhoto+Subtype.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

extension LivePhoto {
    public enum Subtype {
        case live
    }
}

extension LivePhoto.Subtype: MediaSubtypeProvider {
    public var mediaSubtype: MediaSubtype? { .photoLive }
}
