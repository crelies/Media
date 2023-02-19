//
//  BrowserSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import Foundation
import MediaCore

// TODO: macOS
#if !os(tvOS) && !os(macOS)
import AVKit
import Combine
import MediaSwiftUI
import Photos
import SwiftUI

struct Garbage {
    static var cancellables: [AnyCancellable] = []
}

struct BrowserSection: View {
    @State private var isLivePhotoBrowserViewVisible = false
    @State private var isMediaBrowserViewVisible = false
    @State private var isPhotoBrowserViewVisible = false
    @State private var isVideoBrowserViewVisible = false
    @State private var playerURL: URL?
    @State private var image: UniversalImage?
    @State private var livePhoto: PHLivePhoto?
    @State private var livePhotoBrowserSelection: [BrowserResult<LivePhoto, PHLivePhoto>] = []
    @State private var mediaBrowserSelection: [BrowserResult<PHAsset, NSItemProvider>] = []
    @State private var photoBrowserSelection: [BrowserResult<Photo, UniversalImage>] = []
    @State private var videoBrowserSelection: [BrowserResult<Video, URL>] = []

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
                    selection: $livePhotoBrowserSelection.onChange(handleLivePhotoBrowserResult)
                )
            }
            #if !targetEnvironment(macCatalyst) && !os(macOS)
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
                Media.browser(
                    isPresented: $isMediaBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $mediaBrowserSelection.onChange(handleMediaBrowserResult)
                )
            }

            Button(action: {
                isPhotoBrowserViewVisible = true
            }) {
                Text("Photo.browser")
            }
            .fullScreenCover(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                isPhotoBrowserViewVisible = false
            }) {
                Photo.browser(
                    isPresented: $isPhotoBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $photoBrowserSelection.onChange(handlePhotoBrowserResult)
                )
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
                Video.browser(
                    isPresented: $isVideoBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $videoBrowserSelection.onChange(handleVideoBrowserResult)
                )
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
    func handleLivePhotoBrowserResult(_ results: [BrowserResult<LivePhoto, PHLivePhoto>]) {
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

    func handleVideoBrowserResult(_ results: [BrowserResult<Video, URL>]) {
        switch results.first {
        case let .data(url):
            playerURL = url
        default: ()
        }
    }

    func handlePhotoBrowserResult(_ results: [BrowserResult<Photo, UniversalImage>]) {
        switch results.first {
        case let .data(uiImage):
            image = uiImage
        default: ()
        }
    }

    func handleMediaBrowserResult(_ results: [BrowserResult<PHAsset, NSItemProvider>]) {
        switch results.first {
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
    }
}
#endif
