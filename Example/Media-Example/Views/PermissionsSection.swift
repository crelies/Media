//
//  PermissionsSection.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

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
                Text("Trigger camera permission request")
            }

            Button(action: {
                if Media.currentPermission == .limited {
                    isLimitedLibraryPickerPresented = true
                } else {
                    requestPermission()
                }
            }) {
                Text("Trigger photo library permission request")
            }
            .fullScreenCover(isPresented: $isLimitedLibraryPickerPresented, onDismiss: {
                isLimitedLibraryPickerPresented = false
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
        }
    }
}

private extension PermissionsSection {
    func requestPermission() {
        Media.requestPermission(requestedPermission)
    }
}
