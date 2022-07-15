//
//  UniversalImage.swift
//  MediaCore
//
//  Created by Christian Elies on 25.01.21.
//

#if canImport(UIKit)
import UIKit

public typealias UniversalImage = UIImage
#elseif canImport(AppKit)
import AppKit

public typealias UniversalImage = NSImage
#endif
