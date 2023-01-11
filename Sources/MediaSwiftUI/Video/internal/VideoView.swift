//
//  VideoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS)
import AVKit
import SwiftUI

@available(iOS 14, macOS 11, tvOS 14, *)
struct VideoView: View {
    @State private var player = AVPlayer()

    @StateObject var viewModel: VideoViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: viewModel.load)
        case .loaded(let avPlayerItem):
            VideoPlayer(player: player(for: avPlayerItem))
                .onDisappear {
                    player.pause()
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

@available(iOS 14, macOS 11, tvOS 14, *)
private extension VideoView {
    func player(for item: AVPlayerItem) -> AVPlayer {
        if player.currentItem == nil || player.currentItem != item {
            player.replaceCurrentItem(with: item)
        }
        return player
    }
}
#endif
