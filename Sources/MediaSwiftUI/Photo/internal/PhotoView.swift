//
//  PhotoView.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit)
import MediaCore
import Photos
import SwiftUI
import UIKit

// TODO: create a view model

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct PhotoView<ImageView: View>: View {
    enum Error: Swift.Error {
        case invalidData
    }

    @State private var state: ViewState<UIImage> = .loading
    private let imageView: (Image) -> ImageView

    let photo: Photo
    var targetSize: CGSize?
    let contentMode: PHImageContentMode

    var body: some View {
        switch state {
        case .loading:
            UniversalProgressView()
                .onAppear(perform: fetchData)
        case .loaded(let uiImage):
            imageView(Image(uiImage: uiImage))
                .onDisappear {
                    state = .loading
                }
        case .failed(let error):
            Text(error.localizedDescription)
                .onDisappear {
                    state = .loading
                }
        }
    }

    init(photo: Photo, targetSize: CGSize? = nil, contentMode: PHImageContentMode = .aspectFit, @ViewBuilder imageView: @escaping (Image) -> ImageView) {
        self.photo = photo
        self.targetSize = targetSize
        self.contentMode = contentMode
        self.imageView = imageView
    }
}

@available(iOS 13, macOS 10.15, tvOS 13, *)
private extension PhotoView {
    func fetchData() {
        guard state == .loading else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let targetSize = targetSize {
                photo.uiImage(targetSize: targetSize, contentMode: contentMode) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let representation):
                            state = .loaded(value: representation.value)
                        case .failure(let error):
                            state = .failed(error: error)
                        }
                    }
                }
            } else {
                photo.data { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            if let uiImage = UIImage(data: data) {
                                state = .loaded(value: uiImage)
                            } else {
                                state = .failed(error: Error.invalidData)
                            }
                        case .failure(let error):
                            state = .failed(error: error)
                        }
                    }
                }
            }
        }
    }
}
#endif
