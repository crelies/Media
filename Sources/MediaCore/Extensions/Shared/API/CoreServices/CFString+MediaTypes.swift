//
//  CFString+MediaTypes.swift
//  MediaCore
//
//  Created by Christian Elies on 26.11.19.
//

#if !os(tvOS)

#if os(macOS)
import CoreServices
#elseif os(iOS)
import MobileCoreServices
#endif

public extension CFString {
    /// Resolves to the kUTTypeImage CFString
    static var image: CFString { kUTTypeImage }
    /// Resolves to the kUTTypeLivePhoto CFString
    static var livePhoto: CFString { kUTTypeLivePhoto }
    /// Resolves to the kUTTypeMovie CFString
    static var movie: CFString { kUTTypeMovie }
}
#endif
