//
//  CFString+MediaTypes.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

import CoreServices

extension CFString {
    static var image: CFString { kUTTypeImage }
    static var livePhoto: CFString { kUTTypeLivePhoto }
    static var movie: CFString { kUTTypeMovie }
}
