//
//  LivePhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !targetEnvironment(macCatalyst)
import SwiftUI

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, *)
struct LivePhotoView: View {
    @StateObject var viewModel: LivePhotoViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: viewModel.load)
        case let .loaded(phLivePhoto):
            PhotosUILivePhotoView(phLivePhoto: phLivePhoto)
        case let .failed(error):
            Text(error.localizedDescription)
        }
    }
}
#endif
