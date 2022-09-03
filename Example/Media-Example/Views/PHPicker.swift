//
//  PHPicker.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

#if !os(tvOS)
import PhotosUI
import SwiftUI

struct PHPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: uiViewController)
            DispatchQueue.main.async {
                isPresented = false
            }
        }
    }
}

struct PHPicker_Previews: PreviewProvider {
    static var previews: some View {
        PHPicker(isPresented: .constant(false))
    }
}
#endif
