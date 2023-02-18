//
//  PhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

import MediaCore
import SwiftUI

// TODO: outsource
extension Image {
    init(universalImage: UniversalImage) {
        #if os(macOS)
        self = .init(nsImage: universalImage)
        #elseif canImport(UIKit)
        self = .init(uiImage: universalImage)
        #else
        assertionFailure("This should never happen")
        #endif
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *)
struct PhotoView<ImageView: View>: View {
    @StateObject var viewModel: PhotoViewModel
    var imageView: (Image) -> ImageView

    var body: some View {
        switch viewModel.state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: viewModel.load)
        case .loaded(let universalImage):
            imageView(Image(universalImage: universalImage))
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
