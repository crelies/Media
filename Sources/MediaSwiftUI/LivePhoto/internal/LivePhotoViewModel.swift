//
//  LivePhotoViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 11/01/2023.
//

#if canImport(SwiftUI) && !targetEnvironment(macCatalyst)
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
            Task {
                do {
                    let livePhotoDisplayRepresentation = try await self.livePhoto.displayRepresentation(targetSize: self.size)

                    guard livePhotoDisplayRepresentation.quality == .high else {
                        return
                    }

                    guard let phLivePhoto = livePhotoDisplayRepresentation.value as? PHLivePhoto else {
                        return
                    }

                    await self.setState(.loaded(value: phLivePhoto))
                } catch {
                    await self.setState(.failed(error: error))
                }
            }
        }
    }

    @MainActor
    func setState(_ state: ViewState<PHLivePhoto>) {
        self.state = state
    }
}
#endif
