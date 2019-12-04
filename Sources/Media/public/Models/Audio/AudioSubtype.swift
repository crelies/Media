//
//  AudioSubtype.swift
//  
//
//  Created by Christian Elies on 04.12.19.
//

public enum AudioSubtype {}

extension AudioSubtype: MediaSubtypeProvider {
    public var mediaSubtype: MediaSubtype? { nil }
}
