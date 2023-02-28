//
//  PhotoViewModel.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 11/01/2023.
//

#if canImport(SwiftUI)
import Combine
import MediaCore
import Photos
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class PhotoViewModel: ObservableObject {
    enum Error: Swift.Error {
        case invalidData
    }

    @Published var state: ViewState<UniversalImage> = .loading

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
                #if !os(macOS)
                Task {
                    do {
                        let representation = try await self.photo.uiImage(
                            targetSize: targetSize,
                            contentMode: self.contentMode
                        )
                        await self.setState(.loaded(value: representation.value))
                    } catch {
                        await self.setState(.failed(error: error))
                    }
                }
                #else
                self.dataTask()
                #endif
            } else {
                self.dataTask()
            }
        }
    }

    func dataTask() {
        Task {
            do {
                let data = try await self.photo.data()

                if let image = UniversalImage(data: data) {
                    await self.setState(.loaded(value: image))
                } else {
                    await self.setState(.failed(error: Error.invalidData))
                }
            } catch {
                await self.setState(.failed(error: error))
            }
        }
    }

    @MainActor
    func setState(_ state: ViewState<UniversalImage>) {
        self.state = state
    }
}
#endif
