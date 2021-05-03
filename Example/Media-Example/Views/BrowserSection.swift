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
import SwiftUI

extension URL: Identifiable {
    public var id: String { absoluteString }
}

struct BrowserSection: View {
    @State private var isLivePhotoBrowserViewVisible = false
    @State private var isMediaBrowserViewVisible = false
    @State private var isPhotoBrowserViewVisible = false
    @State private var isVideoBrowserViewVisible = false
    @State private var playerURL: URL?

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
                LivePhoto.browser(selectionLimit: 0) { _ in }
            }

            Button(action: {
                isMediaBrowserViewVisible = true
            }) {
                Text("Media.browser")
            }
            .fullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                isMediaBrowserViewVisible = false
            }) {
                Media.browser(selectionLimit: 0) { _ in }
            }

            Button(action: {
                isPhotoBrowserViewVisible = true
            }) {
                Text("Photo.browser")
            }
            .fullScreenCover(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                isPhotoBrowserViewVisible = false
            }) {
                Photo.browser(selectionLimit: 0) { _ in }
            }

            Button(action: {
                isVideoBrowserViewVisible = true
            }) {
                Text("Video.browser")
            }
            .fullScreenCover(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                isVideoBrowserViewVisible = false
            }) {
                Video.browser(selectionLimit: 0, handleVideoBrowserResult)
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
                isVideoBrowserViewVisible = false
                // TODO: improve this
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    playerURL = url
                }
            default: ()
            }
        default: ()
        }
    }
}
