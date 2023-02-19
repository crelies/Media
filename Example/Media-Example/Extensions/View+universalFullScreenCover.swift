//
//  View+universalFullScreenCover.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import SwiftUI

extension View {
    func universalFullScreenCover<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void,
        content: @escaping () -> Content
    ) -> some View {
        #if !os(macOS)
        self.fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: content)
        #else
        self.sheet(isPresented: isPresented, onDismiss: onDismiss, content: content)
        #endif
    }
}
