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
    @Published var state: ViewState<AVPlayerItem> = .loading

    let video: Video

    init(video: Video) {
        self.video = video
    }

    func load() {
        fetchPlayerItem()
    }
}

private extension VideoViewModel {
    func fetchPlayerItem() {
        guard state == .loading else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.video.playerItem { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let avPlayerItem):
                        self.state = .loaded(value: avPlayerItem)
                    case .failure(let error):
                        self.state = .failed(error: error)
                    }
                }
            }
        }
    }
}
#endif
