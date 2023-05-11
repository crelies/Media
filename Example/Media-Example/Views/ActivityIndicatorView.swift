//
//  ActivityIndicatorView.swift
//  Media-Example
//
//  Created by Christian Elies on 03.03.23.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
#endif
