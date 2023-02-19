//
//  View+universalNavigationBarItems.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func universalNavigationBarItems<Leading: View, Trailing: View>(
        leading: Leading,
        trailing: Trailing
    ) -> some View {
        #if os(macOS)
        self.toolbar {
            ToolbarItem {
                leading
            }
            ToolbarItem {
                trailing
            }
        }
        #else
        self.navigationBarItems(leading: leading, trailing: trailing)
        #endif
    }

    func universalNavigationBarItems<Leading: View>(
        leading: Leading
    ) -> some View {
        universalNavigationBarItems(leading: leading, trailing: EmptyView())
    }

    func universalNavigationBarItems<Trailing: View>(
        trailing: Trailing
    ) -> some View {
        universalNavigationBarItems(leading: EmptyView(), trailing: trailing)
    }
}
