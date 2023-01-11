//
//  LivePhotoViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 11/01/2023.
//

#if canImport(SwiftUI) && !os(macOS) && !targetEnvironment(macCatalyst)
import Combine
import MediaCore
import Photos

final class LivePhotoViewModel: ObservableObject {
    @Published private(set) var state: ViewState<PHLivePhoto> = .loading

    let livePhoto: LivePhoto
    let size: CGSize

    init(livePhoto: LivePhoto, size: CGSize) {
        self.livePhoto = livePhoto
        self.size = size
    }

    func load() {
        fetchDisplayRepresentation()
    }
}

private extension LivePhotoViewModel {
    func fetchDisplayRepresentation() {
        guard state == .loading else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.livePhoto.displayRepresentation(targetSize: self.size) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let livePhotoDisplayRepresentation):
                        guard livePhotoDisplayRepresentation.quality == .high else {
                            return
                        }
                        guard let phLivePhoto = livePhotoDisplayRepresentation.value as? PHLivePhoto else {
                            return
                        }
                        self.state = .loaded(value: phLivePhoto)
                    case .failure(let error):
                        self.state = .failed(error: error)
                    }
                }
            }
        }
    }
}
#endif
