//
//  PhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI

@available(iOS 14, macOS 11, tvOS 14, *)
struct PhotoView<ImageView: View>: View {
    @StateObject var viewModel: PhotoViewModel
    var imageView: (Image) -> ImageView

    var body: some View {
        switch viewModel.state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: viewModel.load)
        case .loaded(let uiImage):
            imageView(Image(uiImage: uiImage))
                .onDisappear {
                    viewModel.state = .loading
                }
        case .failed(let error):
            Text(error.localizedDescription)
                .onDisappear {
                    viewModel.state = .loading
                }
        }
    }
}
#endif
