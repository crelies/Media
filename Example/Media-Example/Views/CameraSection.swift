//
//  CameraSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

#if !os(tvOS)
import AVKit
import MediaCore
import MediaSwiftUI
import SwiftUI

struct CameraSection: View {
    @State private var isCameraViewVisible = false
    @State private var isLivePhotoCameraViewVisible = false
    @State private var isPhotoCameraViewVisible = false
    @State private var isVideoCameraViewVisible = false
    #if !os(macOS)
    @State private var capturedMedia: Camera.Result?
    #endif
    @State private var capturedPhoto: Photo.Camera.Result?
    @State private var image: UniversalImage?
    @State private var recordedVideoURL: Media.URL<Video>?
    @State private var playerURL: URL?
    @State private var catchedError: IdentifiableError?

    #if !targetEnvironment(macCatalyst)
    @ObservedObject var cameraViewModel: PhotoCameraViewModel
    #endif

    #if os(macOS)
    @ObservedObject var videoCameraViewModel: VideoCameraViewModel
    #endif

    var body: some View {
        Section(header: Label("Camera", systemImage: "camera")) {
            // TODO: [macOS] reuse existing custom photo camera view
            #if !os(macOS)
            Button(action: {
                isCameraViewVisible = true
            }) {
                Text("Camera.view")
            }
            .fullScreenCover(isPresented: $isCameraViewVisible, onDismiss: {
                isCameraViewVisible = false
            }) {
                Camera.view(selection: $capturedMedia.onChange({ cameraResult in
                    switch cameraResult {
                    case let .tookPhoto(image: image):
                        self.image = image
                    case let .tookVideo(url):
                        self.playerURL = url
                    default: ()
                    }
                }), catchedError: .init(get: { nil }, set: { error in
                    guard let error = error else {
                        return
                    }
                    self.catchedError = .init(error: error)
                }))
            }
            #endif

            #if !targetEnvironment(macCatalyst) && !os(macOS)
            Button(action: {
                isLivePhotoCameraViewVisible = true
            }) {
                Text("LivePhoto.camera")
            }
            .fullScreenCover(isPresented: $isLivePhotoCameraViewVisible, onDismiss: {
                isLivePhotoCameraViewVisible = false
            }) {
                LivePhoto.camera(cameraViewModel: cameraViewModel)
            }
            #endif

            Button(action: {
                isPhotoCameraViewVisible = true
            }) {
                Text("Photo.camera")
            }
            .universalFullScreenCover(isPresented: $isPhotoCameraViewVisible, onDismiss: {
                isPhotoCameraViewVisible = false
            }) {
                #if !os(macOS)
                Photo.camera(selection: $capturedPhoto.onChange({ cameraResult in
                    switch cameraResult {
                    case let .tookPhoto(image: image):
                        self.image = image
                    default: ()
                    }
                }), catchedError: .init(get: { nil }, set: { error in
                    guard let error = error else {
                        return
                    }
                    self.catchedError = .init(error: error)
                }))
                #else
                Photo.camera(viewModel: cameraViewModel)
                    .frame(minWidth: 400, minHeight: 400)
                #endif
            }
            .alert(item: $catchedError) {
                Alert(
                    title: Text("Error"),
                    message: Text($0.error.localizedDescription)
                )
            }
            .sheet(item: $image, onDismiss: {
                image = nil
            }) { uiImage in
                Image(universalImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Button(action: {
                isVideoCameraViewVisible = true
            }) {
                Text("Video.camera")
            }
            .universalFullScreenCover(isPresented: $isVideoCameraViewVisible, onDismiss: {
                isVideoCameraViewVisible = false
            }) {
                #if !os(macOS)
                Video.camera(selection: $recordedVideoURL.onChange({ result in
                    guard let result = result else {
                        return
                    }
                    self.playerURL = result.value
                }), catchedError: .init(get: { nil }, set: { error in
                    guard let error = error else {
                        return
                    }
                    self.catchedError = .init(error: error)
                }))
                #else
                Video.camera(viewModel: videoCameraViewModel)
                    .frame(minWidth: 400, minHeight: 400)
                #endif
            }
            .sheet(item: $playerURL, onDismiss: {
                playerURL = nil
            }) { url in
                VideoPlayer(player: .init(url: url))
            }
        }
    }
}
#endif
