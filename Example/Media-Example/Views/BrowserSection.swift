//
//  BrowserSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import Foundation
import MediaCore

#if !os(tvOS)
import AVKit
import Combine
import MediaSwiftUI
import Photos
import PhotosUI
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
    // New PhotosPicker
    @State private var mediaSelection: [PhotosPickerItem] = []
    @State private var livePhotoSelection: [PhotosPickerItem] = []
    @State private var photoSelection: [PhotosPickerItem] = []
    @State private var videoSelection: [PhotosPickerItem] = []
    // Custom browser
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
            .universalFullScreenCover(isPresented: $isLivePhotoBrowserViewVisible, onDismiss: {
                isLivePhotoBrowserViewVisible = false
            }) {
                #if !os(macOS)
                LivePhoto.browser(
                    isPresented: $isLivePhotoBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $livePhotoBrowserSelection.onChange(handleLivePhotoBrowserResult)
                )
                #else
                PhotosPicker(
                    selection: $livePhotoSelection,
                    maxSelectionCount: nil,
                    selectionBehavior: .ordered,
                    matching: .livePhotos,
                    preferredItemEncoding: .compatible,
                    label: {
                        Text("LivePhoto browser")
                    }
                )
                #endif
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
            .universalFullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                isMediaBrowserViewVisible = false
            }) {
                #if !os(macOS)
                Media.browser(
                    isPresented: $isMediaBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $mediaBrowserSelection.onChange(handleMediaBrowserResult)
                )
                #else
                PhotosPicker(
                    selection: $mediaSelection,
                    maxSelectionCount: nil,
                    selectionBehavior: .ordered,
                    matching: nil,
                    preferredItemEncoding: .compatible,
                    label: {
                        Text("Media browser")
                    }
                )
                #endif
            }

            Button(action: {
                isPhotoBrowserViewVisible = true
            }) {
                Text("Photo.browser")
            }
            .universalFullScreenCover(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                isPhotoBrowserViewVisible = false
            }) {
                #if !os(macOS)
                Photo.browser(
                    isPresented: $isPhotoBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $photoBrowserSelection.onChange(handlePhotoBrowserResult)
                )
                #else
                PhotosPicker(
                    selection: $photoSelection,
                    maxSelectionCount: nil,
                    selectionBehavior: .ordered,
                    matching: .any(of: [.images, .not(.livePhotos)]),
                    preferredItemEncoding: .compatible,
                    label: {
                        Text("Photo browser")
                    }
                )
                #endif
            }
            .background(
                EmptyView()
                    .sheet(item: $image, onDismiss: {
                        image = nil
                    }) { universalImage in
                        Image(universalImage: universalImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
            )

            Button(action: {
                isVideoBrowserViewVisible = true
            }) {
                Text("Video.browser")
            }
            .universalFullScreenCover(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                isVideoBrowserViewVisible = false
            }) {
                #if !os(macOS)
                Video.browser(
                    isPresented: $isVideoBrowserViewVisible,
                    selectionLimit: 0,
                    selection: $videoBrowserSelection.onChange(handleVideoBrowserResult)
                )
                #else
                PhotosPicker(
                    selection: $videoSelection,
                    maxSelectionCount: nil,
                    selectionBehavior: .ordered,
                    matching: .videos,
                    preferredItemEncoding: .compatible,
                    label: {
                        Text("Video browser")
                    }
                )
                #endif
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
    #if !os(macOS)
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
    #endif

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
            #if !os(macOS)
            if itemProvider.canLoadObject(ofClass: PHLivePhoto.self) {
                itemProvider.loadLivePhoto()
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { phLivePhoto in
                        livePhoto = phLivePhoto
                    }
                    .store(in: &Garbage.cancellables)
                return
            }
            #endif

            if itemProvider.canLoadObject(ofClass: UniversalImage.self) {
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
