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

    var requestedPermission: (Result<Void, PermissionError>) -> Void

    var body: some View {
        Section(header: Text("Permissions")) {
            Button(action: {
                Media.requestCameraPermission { _ in
                    cameraPermission = Media.currentCameraPermission
                }
            }) {
                HStack {
                    Text("Trigger camera permission request")
                    Toggle("", isOn: .constant(cameraPermission == .authorized))
                        .disabled(true)
                }
            }

            // TODO: macOS
            #if !os(macOS)
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
        Media.requestPermission { result in
            mediaPermission = Media.currentPermission
            requestedPermission(result)
        }
    }
}
#endif
