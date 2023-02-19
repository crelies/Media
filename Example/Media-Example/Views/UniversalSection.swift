//
//  UniversalSection.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import SwiftUI

struct UniversalSection<Header: View, Content: View>: View {
    let header: Header
    let title: String
    let content: () -> Content

    var body: some View {
        #if !os(macOS)
        Section(header: header, content: content)
        #else
        Section(title, content: content)
        #endif
    }
}
