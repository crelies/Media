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

// Box-type to enable concurrency
private struct AVPlayerItemWrapper {
    let value: AVPlayerItem
}

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
            do {
                guard let avPlayerItem = try await fetchPlayerItem() else {
                    return
                }
                await setPlayerItem(.init(value: avPlayerItem))
                await setState(.loaded(value: avPlayerItem))
            } catch {
                await setState(.failed(error: error))
            }
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
    func fetchPlayerItem() async throws -> AVPlayerItem? {
        guard await state == .loading else {
            return nil
        }

        let video = self.video
        return try await video.playerItem()
    }

    @MainActor
    func setState(_ state: ViewState<AVPlayerItem>) {
        self.state = state
    }

    @MainActor
    func setPlayerItem(_ item: AVPlayerItemWrapper) {
        guard player.currentItem == nil || player.currentItem != item.value else {
            return
        }

        player.replaceCurrentItem(with: item.value)
    }
}
#endif
