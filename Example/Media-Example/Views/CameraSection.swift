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

    #if !targetEnvironment(macCatalyst)
    @ObservedObject var cameraViewModel: CameraViewModel
    #endif

    var body: some View {
        Section(header: Label("Camera", systemImage: "camera")) {
            Button(action: {
                isCameraViewVisible = true
            }) {
                Text("Camera.view")
            }
            .fullScreenCover(isPresented: $isCameraViewVisible, onDismiss: {
                isCameraViewVisible = false
            }) {
                Camera.view { _ in }
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
                LivePhoto.camera(cameraViewModel: cameraViewModel)
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
                Photo.camera { _ in }
            }

            Button(action: {
                isVideoCameraViewVisible = true
            }) {
                Text("Video.camera")
            }
            .fullScreenCover(isPresented: $isVideoCameraViewVisible, onDismiss: {
                isVideoCameraViewVisible = false
            }) {
                Video.camera { _ in }
            }
        }
    }
}
