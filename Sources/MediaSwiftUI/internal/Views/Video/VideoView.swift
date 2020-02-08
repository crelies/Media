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
    @State private var avPlayerItem: AVPlayerItem?
    @State private var error: Error?

    let video: Video

    var body: some View {
        fetchPlayerItem()

        return Group {
            avPlayerItem.map { AVPlayerView(avPlayerItem: $0) }

            error.map { Text($0.localizedDescription) }
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
