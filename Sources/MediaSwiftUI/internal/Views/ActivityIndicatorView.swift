//
//  ActivityIndicatorView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15.02.21.
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
