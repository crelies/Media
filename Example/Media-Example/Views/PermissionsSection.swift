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
                VStack(alignment: .leading) {
                    Text("Trigger camera permission request")
                    Text("\(String(describing: Media.currentCameraPermission))").font(.footnote)
                }
            }

            Button(action: {
                if Media.currentPermission == .limited {
                    isLimitedLibraryPickerPresented = true
                } else {
                    requestPermission()
                }
            }) {
                VStack(alignment: .leading) {
                    Text("Trigger photo library permission request")
                    Text("\(String(describing: Media.currentPermission))").font(.footnote)
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
