//
//  AddAlbumScreen.swift
//  Media-Example
//
//  Created by Christian Elies on 19.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AddAlbumScreen: View {
    @Environment(\.presentationMode) private var presentationMode

    @State private var albumName = ""
    @State private var isAddConfirmationAlertPresented = false
    @State private var addResult: Result<Void, Error>?

    var body: some View {
        NavigationView {
            Form {
                TextField("Album name", text: $albumName)

                Button(action: createAlbum) {
                    Text("Create")
                }
                .disabled(albumName.count <= 3)
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
            .alert(isPresented: $isAddConfirmationAlertPresented) {
                switch addResult {
                case .success:
                    return Alert(title: Text("Success"), message: Text("Album added"), dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
                case .failure(let error):
                    return Alert(title: Text("Failure"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
                case .none:
                    return Alert(title: Text("Failure"), message: Text("An unknown error occurred"), dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private extension AddAlbumScreen {
    func createAlbum() {
        guard albumName.count > 3 else {
            return
        }

        Album.create(title: albumName) { result in
            addResult = result
            isAddConfirmationAlertPresented = true
        }
    }
}
