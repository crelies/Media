//
//  LivePhotoView.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

import Photos
import SwiftUI

@available(iOS 13, *)
struct LivePhotoView: View {
    @State private var phLivePhoto: PHLivePhoto?
    @State private var error: Error?

    let livePhoto: LivePhoto
    let size: CGSize

    var body: some View {
        if phLivePhoto == nil && error == nil {
            self.livePhoto.displayRepresentation(targetSize: self.size) { result in
                switch result {
                case .success(let livePhotoDisplayRepresentation):
                    guard livePhotoDisplayRepresentation.quality == .high else {
                        return
                    }
                    self.phLivePhoto = livePhotoDisplayRepresentation.livePhoto
                case .failure(let error):
                    self.error = error
                }
            }
        }

        return Group {
            phLivePhoto.map { PhotosUILivePhotoView(phLivePhoto: $0) }

            error.map { Text($0.localizedDescription) }
        }
    }
}
