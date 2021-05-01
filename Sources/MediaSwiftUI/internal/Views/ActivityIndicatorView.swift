//
//  ActivityIndicatorView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15.02.21.
//

import SwiftUI
import UIKit

struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
