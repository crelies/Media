//
//  Image+universalImage.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 19/02/2023.
//

import MediaCore
import SwiftUI

extension Image {
    public init(universalImage: UniversalImage) {
        #if os(macOS)
        self = .init(nsImage: universalImage)
        #elseif canImport(UIKit)
        self = .init(uiImage: universalImage)
        #else
        assertionFailure("This should never happen")
        #endif
    }
}
