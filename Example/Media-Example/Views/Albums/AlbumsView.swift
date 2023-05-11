//
//  AlbumsView.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AlbumsView: View {
    @State private var viewState: ViewState<[Album]> = .loading
    @State private var isAddViewVisible = false
    @State private var indexSetToDelete: IndexSet?

    let albums: [Album]

    var body: some View {
        switch viewState {
        case .loading:
            ProgressView("Fetching media from \(albums.count) albums ...")
                .onAppear(perform: load)
        case let .loaded(albums):
            List {
                ForEach(0..<albums.count, id: \.self) { index in
                    let album = albums[index]
                    NavigationLink(destination: AlbumView(album: album)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(album.localizedTitle ?? album.id)")
                                Text("(asset count: \(album.allMedia.count))").font(.footnote)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .secondarySystemBackground()
                    .cornerRadius(16)
                }
                .onDelete { indexSet in
                    indexSetToDelete = indexSet
                }
            }
            #if !os(tvOS) && !os(macOS)
            .listStyle(.plain)
            #endif
            .universalInlineNavigationTitle("Albums")
            .universalNavigationBarItems(trailing: Button(action: {
                isAddViewVisible = true
            }) {
                Text("Add")
            }
            .sheet(isPresented: $isAddViewVisible, onDismiss: {
                isAddViewVisible = false
            }) {
                AddAlbumScreen()
            })
            .alert(item: $indexSetToDelete) { indexSet in
                deleteConfirmationAlert(indexSetToDelete: indexSet)
            }
        case let .failed(error):
            Text(error.localizedDescription)
        }
    }
}

private extension AlbumsView {
    func load() {
        viewState = .loaded(value: albums)
    }

    func albums(at indexSet: IndexSet) -> [Album] {
        var result: [Album] = []
        for index in indexSet {
            guard index >= 0, index < albums.count else {
                continue
            }

            let album = albums[index]
            result.append(album)
        }
        return result
    }

    func deleteConfirmationAlert(indexSetToDelete: IndexSet) -> Alert {
        let albumsToDelete = albums(at: indexSetToDelete)
        let albumsToDeleteSummary = albumsToDelete.map { $0.localizedTitle ?? "Unknown title" }.joined(separator: ", ")

        return Alert(title: Text("Are you sure?"), message: Text("[\(albumsToDeleteSummary)] will be deleted"), primaryButton: .default(Text("Yes")) {
            Task { @MainActor in
                let albumsToDelete = albums(at: indexSetToDelete)

                guard !albumsToDelete.isEmpty else {
                    self.indexSetToDelete = nil
                    return
                }

                for album in albumsToDelete {
                    try await album.delete()
                }

                self.indexSetToDelete = nil
            }
        }, secondaryButton: .cancel() {
            self.indexSetToDelete = nil
        })
    }
}

struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: Albums.cloud)
    }
}
