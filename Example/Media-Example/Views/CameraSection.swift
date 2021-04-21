//
//  CameraSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import MediaSwiftUI
import SwiftUI

struct CameraSection: View {
    @State private var isCameraViewVisible = false
    @State private var isLivePhotoCameraViewVisible = false
    @State private var isPhotoCameraViewVisible = false
    @State private var isVideoCameraViewVisible = false

    var body: some View {
        Section {
            Button(action: {
                isCameraViewVisible = true
            }) {
                Text("Camera.view")
            }
            .fullScreenCover(isPresented: $isCameraViewVisible, onDismiss: {
                isCameraViewVisible = false
            }) {
                let result = Result {
                    try Camera.view { _ in }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }

            #if !targetEnvironment(macCatalyst)
            Button(action: {
                isLivePhotoCameraViewVisible = true
            }) {
                Text("LivePhoto.camera")
            }
            .fullScreenCover(isPresented: $isLivePhotoCameraViewVisible, onDismiss: {
                isLivePhotoCameraViewVisible = false
            }) {
                let result = Result {
                    try LivePhoto.camera { result in
                        guard let livePhotoData = try? result.get() else {
                            return
                        }

                        try? LivePhoto.save(data: livePhotoData) { result in
                            switch result {
                            case .failure(let error):
                                debugPrint("Live photo save error: \(error)")
                            default: ()
                            }
                        }
                    }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
            #endif

            Button(action: {
                isPhotoCameraViewVisible = true
            }) {
                Text("Photo.camera")
            }
            .fullScreenCover(isPresented: $isPhotoCameraViewVisible, onDismiss: {
                isPhotoCameraViewVisible = false
            }) {
                let result = Result {
                    try Photo.camera { _ in }
                }

                switch result {
                case let .success(view):
                    view
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }

            Button(action: {
                isVideoCameraViewVisible = true
            }) {
                Text("Video.camera")
            }
            .fullScreenCover(isPresented: $isVideoCameraViewVisible, onDismiss: {
                isVideoCameraViewVisible = false
            }) {
                let result = Result {
                    try Video.camera { _ in }
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
