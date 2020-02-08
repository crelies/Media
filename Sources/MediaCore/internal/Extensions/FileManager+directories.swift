//
//  FileManager+directories.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import Foundation

// TODO: public
public extension FileManager {
    var cachesDirectory: URL {
        urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
