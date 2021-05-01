//
//  PermissionsSection.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import AVFoundation
import MediaCore
import SwiftUI

struct PermissionsSection: View {
    @State private var isLimitedLibraryPickerPresented = false

    var requestedPermission: (Result<Void, PermissionError>) -> Void
    
    var body: some View {
        Section(header: Text("Permissions")) {
            Button(action: {
                Media.requestCameraPermission { result in
                    debugPrint(result)
                }
            }) {
                HStack {
                    Text("Trigger camera permission request")
                    Toggle("", isOn: .constant(Media.currentCameraPermission == .authorized))
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
                    Toggle("", isOn: .constant(Media.currentPermission == .authorized))
                        .disabled(true)
                }
            }
            .background(PHPicker(isPresented: $isLimitedLibraryPickerPresented))
        }
    }
}

private extension PermissionsSection {
    func requestPermission() {
        Media.requestPermission(requestedPermission)
    }
}
