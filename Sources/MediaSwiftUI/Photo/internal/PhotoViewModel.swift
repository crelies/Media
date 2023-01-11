//
//  PhotoViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 11/01/2023.
//

#if canImport(SwiftUI) && canImport(UIKit)
import Combine
import MediaCore
import Photos
import UIKit

final class PhotoViewModel: ObservableObject {
    enum Error: Swift.Error {
        case invalidData
    }

    @Published var state: ViewState<UIImage> = .loading

    let photo: Photo
    var targetSize: CGSize?
    let contentMode: PHImageContentMode

    init(photo: Photo, targetSize: CGSize? = nil, contentMode: PHImageContentMode = .aspectFit) {
        self.photo = photo
        self.targetSize = targetSize
        self.contentMode = contentMode
    }

    func load() {
        fetchData()
    }
}

private extension PhotoViewModel {
    func fetchData() {
        guard state == .loading else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            if let targetSize = self.targetSize {
                self.photo.uiImage(targetSize: targetSize, contentMode: self.contentMode) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let representation):
                            self.state = .loaded(value: representation.value)
                        case .failure(let error):
                            self.state = .failed(error: error)
                        }
                    }
                }
            } else {
                self.photo.data { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            if let uiImage = UIImage(data: data) {
                                self.state = .loaded(value: uiImage)
                            } else {
                                self.state = .failed(error: Error.invalidData)
                            }
                        case .failure(let error):
                            self.state = .failed(error: error)
                        }
                    }
                }
            }
        }
    }
}
#endif
