//
//  VideoView.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS)
import AVFoundation
import MediaCore
import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct VideoView: View {
    private let viewWrapper = ViewWrapper<AVPlayerView>()

    @State private var avPlayerItem: AVPlayerItem?
    @State private var error: Error?

    let video: Video

    var body: some View {
        fetchPlayerItem()

        return Group {
            avPlayerItem.map { item -> AVPlayerView in
                let player = AVPlayerView(avPlayerItem: item)
                viewWrapper.value = player
                return player
            }

            error.map { Text($0.localizedDescription) }
        }.onDisappear {
            self.viewWrapper.value?.pause()
        }
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, *)
extension VideoView {
    private func fetchPlayerItem() {
        if avPlayerItem == nil && error == nil {
            self.video.playerItem { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let avPlayerItem):
                        self.avPlayerItem = avPlayerItem
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
}
#endif
