//
//  BrowserSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import AVKit
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

struct BrowserSection: View {
    @State private var isLivePhotoBrowserViewVisible = false
    @State private var isMediaBrowserViewVisible = false
    @State private var isPhotoBrowserViewVisible = false
    @State private var isVideoBrowserViewVisible = false
    @State private var playerURL: URL?
    @State private var image: UIImage?
    @State private var livePhoto: PHLivePhoto?

    var body: some View {
        Section(header: Label("Browser", systemImage: "photo.on.rectangle.angled")) {
            Button(action: {
                isLivePhotoBrowserViewVisible = true
            }) {
                Text("LivePhoto.browser")
            }
            .fullScreenCover(isPresented: $isLivePhotoBrowserViewVisible, onDismiss: {
                isLivePhotoBrowserViewVisible = false
            }) {
                LivePhoto.browser(isPresented: $isLivePhotoBrowserViewVisible, selectionLimit: 0, handleLivePhotoBrowserResult)
            }
            .background(
                EmptyView()
                    .sheet(item: $livePhoto, onDismiss: {
                        livePhoto = nil
                    }) { livePhoto in
                        PhotosUILivePhotoView(phLivePhoto: livePhoto)
                    }
            )

            Button(action: {
                isMediaBrowserViewVisible = true
            }) {
                Text("Media.browser")
            }
            .fullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                isMediaBrowserViewVisible = false
            }) {
                Media.browser(isPresented: $isMediaBrowserViewVisible, selectionLimit: 0) { result in
                    debugPrint(result)
                }
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

    func handleLivePhotoBrowserResult(_ result: Result<[BrowserResult<LivePhoto, PHLivePhoto>], Swift.Error>) {
        switch result {
        case let .success(browserResult):
            switch browserResult.first {
            case let .data(phLivePhoto):
                livePhoto = phLivePhoto
            default: ()
            }
        default: ()
        }
    }
}
