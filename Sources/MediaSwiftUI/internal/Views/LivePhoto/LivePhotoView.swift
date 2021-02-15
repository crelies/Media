//
//  LivePhotoView.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && !os(macOS) && !targetEnvironment(macCatalyst)
import MediaCore
import Photos
import SwiftUI

// TODO: refactor
@available(iOS 13, tvOS 13, *)
struct LivePhotoView: View {
    @State private var phLivePhoto: PHLivePhoto?
    @State private var error: Error?

    let livePhoto: LivePhoto
    let size: CGSize

    var body: some View {
        fetchDisplayRepresentation()

        return Group {
            phLivePhoto.map { PhotosUILivePhotoView(phLivePhoto: $0) }

            error.map { Text($0.localizedDescription) }
        }
    }
}

@available(iOS 13, tvOS 13, *)
extension LivePhotoView {
    private func fetchDisplayRepresentation() {
        if phLivePhoto == nil && error == nil {
            self.livePhoto.displayRepresentation(targetSize: self.size) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let livePhotoDisplayRepresentation):
                        guard livePhotoDisplayRepresentation.quality == .high else {
                            return
                        }
                        self.phLivePhoto = livePhotoDisplayRepresentation.value as? PHLivePhoto
                    case .failure(let error):
                        self.error = error
                    }
                }
            }
        }
    }
}
#endif
