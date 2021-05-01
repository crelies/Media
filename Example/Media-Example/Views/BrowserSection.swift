//
//  BrowserSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import MediaSwiftUI
import SwiftUI

struct BrowserSection: View {
    @State private var isLivePhotoBrowserViewVisible = false
    @State private var isMediaBrowserViewVisible = false
    @State private var isPhotoBrowserViewVisible = false
    @State private var isVideoBrowserViewVisible = false

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
                LivePhoto.browser { _ in }
            }

            Button(action: {
                isMediaBrowserViewVisible = true
            }) {
                Text("Media.browser")
            }
            .fullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                isMediaBrowserViewVisible = false
            }) {
                Media.browser { _ in }
            }

            Button(action: {
                isPhotoBrowserViewVisible = true
            }) {
                Text("Photo.browser")
            }
            .fullScreenCover(isPresented: $isPhotoBrowserViewVisible, onDismiss: {
                isPhotoBrowserViewVisible = false
            }) {
                Photo.browser { _ in }
            }

            Button(action: {
                isVideoBrowserViewVisible = true
            }) {
                Text("Video.browser")
            }
            .fullScreenCover(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                isVideoBrowserViewVisible = false
            }) {
                Video.browser { _ in }
            }
        }
    }
}
