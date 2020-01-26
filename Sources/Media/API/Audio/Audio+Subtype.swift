//
//  Audio+Subtype.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

extension Audio {
    public enum Subtype {}
}

extension Audio.Subtype: MediaSubtypeProvider {
    public var mediaSubtype: MediaSubtype? { nil }
}
