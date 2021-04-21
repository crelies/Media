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
        Section {
            Button(action: {
                isLivePhotoBrowserViewVisible = true
            }) {
                Text("LivePhoto.browser")
            }
            .fullScreenCover(isPresented: $isLivePhotoBrowserViewVisible, onDismiss: {
                isLivePhotoBrowserViewVisible = false
            }) {
                let result = Result {
                    try LivePhoto.browser { _ in }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }

            Button(action: {
                isMediaBrowserViewVisible = true
            }) {
                Text("Media.browser")
            }
            .fullScreenCover(isPresented: $isMediaBrowserViewVisible, onDismiss: {
                isMediaBrowserViewVisible = false
            }) {
                let result = Result {
                    try Media.browser { _ in }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
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
                let result = Result {
                    try Photo.browser { _ in }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }

            Button(action: {
                isVideoBrowserViewVisible = true
            }) {
                Text("Video.browser")
            }
            .fullScreenCover(isPresented: $isVideoBrowserViewVisible, onDismiss: {
                isVideoBrowserViewVisible = false
            }) {
                let result = Result {
                    try Video.browser { _ in }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
        }
    }
}
