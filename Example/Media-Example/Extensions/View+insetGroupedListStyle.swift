//
//  View+insetGroupedListStyle.swift
//  Media-Example
//
//  Created by Christian Elies on 01.03.23.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import SwiftUI

extension View {
    func insetGroupedListStyle() -> some View {
        #if !os(tvOS) && !os(macOS)
        self.listStyle(InsetGroupedListStyle())
        #else
        self
        #endif
    }
}
