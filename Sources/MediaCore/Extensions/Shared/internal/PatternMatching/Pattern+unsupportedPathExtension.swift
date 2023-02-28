//
//  Pattern+unsupportedPathExtension.swift
//  MediaCore
//
//  Created by Christian Elies on 01.12.19.
//

extension Pattern where Value: Hashable {
    static func unsupportedPathExtension(supportedPathExtensions: Set<Value>) -> Pattern {
        Pattern { !supportedPathExtensions.contains($0) }
    }
}
