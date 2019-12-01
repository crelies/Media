//
//  PhotoView.swift
//  
//
//  Created by Christian Elies on 28.11.19.
//

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit

@available(iOS 13, macOS 10.15, tvOS 13, *)
struct PhotoView<ImageView: View>: View {
    @State private var data: Data?
    @State private var image: UIImage?
    @State private var error: Error?
    private let imageView: (Image) -> ImageView

    let photo: Photo

    var body: some View {
        if data == nil && image == nil && error == nil {
            self.photo.data { result in
                switch result {
                case .success(let data):
                    self.data = data
                case .failure(let error):
                    self.error = error
                }
            }
        }

        return Group {
            data.map { UIImage(data: $0).map { self.imageView(Image(uiImage: $0)) } }

            error.map { Text($0.localizedDescription) }
        }
    }

    init(photo: Photo,
         @ViewBuilder imageView: @escaping (Image) -> ImageView) {
        self.photo = photo
        self.imageView = imageView
    }
}
#endif
