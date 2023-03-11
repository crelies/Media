//
//  View+secondarySystemBackground.swift
//  Media-Example
//
//  Created by Christian Elies on 01.03.23.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import SwiftUI

extension View {
    func secondarySystemBackground() -> some View {
        #if !os(tvOS) && !os(macOS)
        self.background(Color(.secondarySystemBackground))
        #else
        self
        #endif
    }
}
