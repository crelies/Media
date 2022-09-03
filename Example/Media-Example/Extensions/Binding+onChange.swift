//
//  Binding+onChange.swift
//  Media-Example
//
//  Created by Christian Elies on 03/09/2022.
//  Copyright © 2022 Christian Elies. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
