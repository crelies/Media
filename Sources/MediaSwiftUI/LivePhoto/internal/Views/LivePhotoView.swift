//
//  LivePhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS) && !targetEnvironment(macCatalyst)
import MediaCore
import Photos
import SwiftUI

// TODO: create a view model

@available(iOS 13, tvOS 13, *)
struct LivePhotoView: View {
    @State private var state: ViewState<PHLivePhoto> = .loading

    let livePhoto: LivePhoto
    let size: CGSize

    var body: some View {
        switch state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: fetchDisplayRepresentation)
        case let .loaded(phLivePhoto):
            PhotosUILivePhotoView(phLivePhoto: phLivePhoto)
        case let .failed(error):
            Text(error.localizedDescription)
        }
    }
}

@available(iOS 13, tvOS 13, *)
extension LivePhotoView {
    private func fetchDisplayRepresentation() {
        guard state == .loading else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            livePhoto.displayRepresentation(targetSize: size) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let livePhotoDisplayRepresentation):
                        guard livePhotoDisplayRepresentation.quality == .high else {
                            return
                        }
                        guard let phLivePhoto = livePhotoDisplayRepresentation.value as? PHLivePhoto else {
                            return
                        }
                        state = .loaded(value: phLivePhoto)
                    case .failure(let error):
                        state = .failed(error: error)
                    }
                }
            }
        }
    }
}
#endif
