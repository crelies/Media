//
//  BrowserSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import AVKit
import Combine
import Foundation
import MediaCore
import MediaSwiftUI
import Photos
import SwiftUI

extension URL: Identifiable {
    public var id: String { absoluteString }
}

extension UIImage: Identifiable {
    public var id: UIImage { self }
}

extension PHLivePhoto: Identifiable {
    public var id: PHLivePhoto { self }
}

struct Garbage {
    static var cancellables: [AnyCancellable] = []
}

struct BrowserSection: View {
    @State private var isLivePhotoBrowserViewVisible = false
    @State private var isMediaBrowserViewVisible = false
    @State private var isPhotoBrowserViewVisible = false
    @State private var isVideoBrowserViewVisible = false
    @State private var playerURL: URL?
    @State private var image: UIImage?
    @State private var livePhoto: PHLivePhoto?
    @State private var livePhotoBrowserSelection: [BrowserResult<LivePhoto, PHLivePhoto>] = []

    var body: some View {
        Section(header: Label("Browser", systemImage: "photo.on.rectangle.angled")) {
            Button(action: {
                isLivePhotoBrowserViewVisible = true
            }) {
                Text("LivePhoto.browser (selected: \(livePhotoBrowserSelection.count))")
            }
            .fullScreenCover(isPresented: $isLivePhotoBrowserViewVisible, onDismiss: {
                isLivePhotoBrowserViewVisible = false
            }) {
                LivePhoto.browser(
                    isPresented: $isLivePhotoBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $livePhotoBrowserSelection.onChange { results in
                        switch results.first {
                        case let .data(phLivePhoto):
                            livePhoto = phLivePhoto
                        case let .media(_, itemProvider):
                            guard let itemProvider = itemProvider else {
                                return
                            }

                            itemProvider.loadLivePhoto()
                                .receive(on: DispatchQueue.main)
                                .sink { result in
                                    switch result {
                                    case let .failure(error):
                                        debugPrint(error)
                                    case .finished: ()
                                    }
                                } receiveValue: { value in
                                    self.livePhoto = value
                                }
                                .store(in: &Garbage.cancellables)
                        default: ()
                        }
                    }
                )
            }
            #if !targetEnvironment(macCatalyst)
            .background(
                EmptyView()
                    .sheet(item: $livePhoto, onDismiss: {
                        livePhoto = nil
                    }) { livePhoto in
                        PhotosUILivePhotoView(phLivePhoto: livePhoto)
                    }
            )
            #endif

            Button(action: {
                isMediaBrowserViewVisible = true
            }) {
                Text("Media.browser")
            }
            .fullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                isMediaBrowserViewVisible = false
            }) {
                Media.browser(isPresented: $isMediaBrowserViewVisible, selectionLimit: 0, handleMediaBrowserResult)
            }

            Button(action: {
                isPhotoBrowserViewVisible = true
            }) {
                Text("Photo.browser")
            }
            .fullScreenCover(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                isPhotoBrowserViewVisible = false
            }) {
                Photo.browser(isPresented: $isPhotoBrowserViewVisible, selectionLimit: 0, handlePhotoBrowserResult)
            }
            .background(
                EmptyView()
                    .sheet(item: $image, onDismiss: {
                        image = nil
                    }) { uiImage in
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
            )

            Button(action: {
                isVideoBrowserViewVisible = true
            }) {
                Text("Video.browser")
            }
            .fullScreenCover(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                isVideoBrowserViewVisible = false
            }) {
                Video.browser(isPresented: $isVideoBrowserViewVisible, selectionLimit: 0, handleVideoBrowserResult)
            }
            .background(
                EmptyView()
                    .sheet(item: $playerURL, onDismiss: {
                        playerURL = nil
                    }) { url in
                        VideoPlayer(player: .init(url: url))
                    }
            )
        }
    }
}

private extension BrowserSection {
    func handleVideoBrowserResult(_ result: Result<[BrowserResult<Video, URL>], Swift.Error>) {
        switch result {
        case let .success(browserResult):
            switch browserResult.first {
            case let .data(url):
                playerURL = url
            default: ()
            }
        default: ()
        }
    }

    func handlePhotoBrowserResult(_ result: Result<[BrowserResult<Photo, UIImage>], Swift.Error>) {
        switch result {
        case let .success(browserResult):
            switch browserResult.first {
            case let .data(uiImage):
                image = uiImage
            default: ()
            }
        default: ()
        }
    }

    func handleMediaBrowserResult(_ result: Result<[BrowserResult<PHAsset, NSItemProvider>], Swift.Error>) {
        switch result {
        case let .success(browserResult):
            switch browserResult.first {
            case let .data(itemProvider):
                if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
                    itemProvider.loadLivePhoto()
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { _ in }) { phLivePhoto in
                            livePhoto = phLivePhoto
                        }
                        .store(in: &Garbage.cancellables)
                } else if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadImage()
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { _ in }) { uiImage in
                            image = uiImage
                        }
                        .store(in: &Garbage.cancellables)
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    itemProvider.loadVideo()
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { _ in }) { url in
                            playerURL = url
                        }
                        .store(in: &Garbage.cancellables)
                }
            default: ()
            }
        default: ()
        }
    }
}
