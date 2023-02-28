//
//  VideoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI)
import AVKit
import SwiftUI

@available(iOS 14, macOS 11, tvOS 14, *)
struct VideoView: View {
    @StateObject var viewModel: VideoViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: viewModel.load)
        case .loaded:
            VideoPlayer(player: viewModel.player)
                .onDisappear {
                    viewModel.disappear()
                }
        case .failed(let error):
            Text(error.localizedDescription)
                .onDisappear {
                    viewModel.disappear()
                }
        }
    }
}
#endif
