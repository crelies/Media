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
            ScrollView {
                LazyVStack(alignment: .leading) {
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
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    .onDelete { indexSet in
                        indexSetToDelete = indexSet
                    }
                }
                .padding()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Albums"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
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

    func deleteConfirmationAlert(indexSetToDelete: IndexSet) -> Alert {
        var albumsToDelete: [Album] = []
        for index in indexSetToDelete {
            guard index >= 0, index < albums.count else {
                continue
            }

            let album = albums[index]
            albumsToDelete.append(album)
        }

        let albumsToDeleteSummary = albumsToDelete.map { $0.localizedTitle ?? "Unknown title" }.joined(separator: ", ")

        return Alert(title: Text("Are you sure?"), message: Text("[\(albumsToDeleteSummary)] will be deleted"), primaryButton: .default(Text("Yes")) {
            guard !albumsToDelete.isEmpty else {
                self.indexSetToDelete = nil
                return
            }

            albumsToDelete.forEach { $0.delete { _ in } }

            self.indexSetToDelete = nil
        }, secondaryButton: .cancel() {
            self.indexSetToDelete = nil
        })
    }
}

#if DEBUG
struct AlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumsView(albums: Albums.cloud)
    }
}
#endif
