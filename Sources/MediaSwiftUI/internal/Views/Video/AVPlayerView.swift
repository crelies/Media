//
//  AVPlayerView.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS)
import AVKit
import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct AVPlayerView: UIViewControllerRepresentable {
    let avPlayerItem: AVPlayerItem

    func makeUIViewController(context: UIViewControllerRepresentableContext<AVPlayerView>) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        let player = AVPlayer(playerItem: avPlayerItem)
        viewController.player = player
        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<AVPlayerView>) {

    }
}
#endif
