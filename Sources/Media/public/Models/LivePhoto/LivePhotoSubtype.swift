//
//  LivePhotoSubtype.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

public enum LivePhotoSubtype {
    case live
}

extension LivePhotoSubtype: MediaSubtypeProvider {
    public var mediaSubtype: MediaSubtype? { .photoLive }
}
