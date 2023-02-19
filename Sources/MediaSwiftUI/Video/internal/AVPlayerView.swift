//
//  AVPlayerView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS)
import AVKit
import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct AVPlayerView: UIViewControllerRepresentable {
    private let wrapper = WeakObjectWrapper<AVPlayer>()

    let avPlayerItem: AVPlayerItem

    func makeUIViewController(context: UIViewControllerRepresentableContext<AVPlayerView>) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        let player = AVPlayer(playerItem: avPlayerItem)
        viewController.player = player
        wrapper.value = player
        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<AVPlayerView>) {
        uiViewController.player?.pause()
    }

    func pause() {
        wrapper.value?.pause()
    }
}
#endif
