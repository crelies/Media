//
//  CFString+MediaTypes.swift
//  
//
//  Created by Christian Elies on 26.11.19.
//

#if !os(tvOS)

#if os(macOS)
import CoreServices
#elseif os(iOS)
import MobileCoreServices
#endif

// TODO: Public
public extension CFString {
    static var image: CFString { kUTTypeImage }
    static var livePhoto: CFString { kUTTypeLivePhoto }
    static var movie: CFString { kUTTypeMovie }
}
#endif
