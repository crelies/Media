//
//  View+universalNavigationTitle.swift
//  Media-Example
//
//  Created by Christian Elies on 28.02.23.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import SwiftUI

extension View {
    func universalInlineNavigationTitle(
        _ title: String
    ) -> some View {
        #if !os(tvOS) && !os(macOS)
        self.navigationBarTitle(title, displayMode: .inline)
        #else
        self.navigationTitle(Text(title))
        #endif
    }
}
