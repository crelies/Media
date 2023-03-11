//
//  PermissionsSection.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

#if !os(tvOS)
import AVFoundation
import MediaCore
import Photos
import SwiftUI

struct PermissionsSection: View {
    @State private var isLimitedLibraryPickerPresented = false
    @State private var cameraPermission: AVAuthorizationStatus = .notDetermined
    @State private var mediaPermission: PHAuthorizationStatus = .notDetermined

    var body: some View {
        Section(header: Text("Permissions")) {
            Button(action: {
                Task { @MainActor in
                    _ = await Media.requestCameraPermission()
                    self.cameraPermission = Media.currentCameraPermission
                }
            }) {
                HStack {
                    Text("Trigger camera permission request")
                    Toggle("", isOn: .constant(cameraPermission == .authorized))
                        .disabled(true)
                }
            }

            Button(action: {
                if Media.currentPermission == .limited {
                    isLimitedLibraryPickerPresented = true
                } else {
                    requestPermission()
                }
            }) {
                HStack {
                    Text("Trigger photo library permission request")
                    Toggle("", isOn: .constant(mediaPermission == .authorized))
                        .disabled(true)
                }
            }
            #if !os(macOS)
            .background(PHPicker(isPresented: $isLimitedLibraryPickerPresented))
            #endif
        }
        .onAppear {
            cameraPermission = Media.currentCameraPermission
            mediaPermission = Media.currentPermission
        }
    }
}

private extension PermissionsSection {
    func requestPermission() {
        Task { @MainActor in
            _ = await Media.requestPermission()
            mediaPermission = Media.currentPermission
        }
    }
}
#endif
