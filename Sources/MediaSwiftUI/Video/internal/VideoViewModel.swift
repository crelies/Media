//
//  VideoViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 11/01/2023.
//

#if canImport(SwiftUI)
import AVKit
import Combine
import MediaCore

final class VideoViewModel: ObservableObject {
    private(set) var player = AVPlayer()

    @Published
    @MainActor
    private(set) var state: ViewState<AVPlayerItem> = .loading

    let video: Video

    init(video: Video) {
        self.video = video
    }
}

extension VideoViewModel {
    func load() {
        Task {
            await fetchPlayerItem()
        }
    }

    func pause() {
        player.pause()
    }

    @MainActor
    func disappear() {
        if case ViewState.loaded = state {
            pause()
        }
        state = .loading
    }
}

private extension VideoViewModel {
    @MainActor
    func fetchPlayerItem() {
        guard state == .loading else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            Task {
                do {
                    let avPlayerItem = try await self.video.playerItem()
                    await self.setPlayerItem(avPlayerItem)
                    await self.setState(.loaded(value: avPlayerItem))
                } catch {
                    await self.setState(.failed(error: error))
                }
            }
        }
    }

    @MainActor
    func setState(_ state: ViewState<AVPlayerItem>) {
        self.state = state
    }

    @MainActor
    func setPlayerItem(_ item: AVPlayerItem) {
        guard player.currentItem == nil || player.currentItem != item else {
            return
        }

        player.replaceCurrentItem(with: item)
    }
}
#endif
