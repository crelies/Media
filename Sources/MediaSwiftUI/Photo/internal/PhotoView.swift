//
//  PhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct PhotoView<ImageView: View>: View {
    private let imageView: (Image) -> ImageView

    @ObservedObject var viewModel: PhotoViewModel

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

    init(viewModel: PhotoViewModel, @ViewBuilder imageView: @escaping (Image) -> ImageView) {
        self.viewModel = viewModel
        self.imageView = imageView
    }
}
#endif
