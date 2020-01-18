//
//  FileManager+directories.swift
//  
//
//  Created by Christian Elies on 16.01.20.
//

import Foundation

extension FileManager {
    var userDocumentsDirectory: URL {
        // TODO: remove force unwrap
        urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    var cachesDirectory: URL {
        // TODO: remove force unwrap
        urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
