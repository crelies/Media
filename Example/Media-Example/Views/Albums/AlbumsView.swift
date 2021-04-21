//
//  AlbumsView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

extension IndexSet: Identifiable {
    public var id: Self { self }
}

enum ViewState<T: Hashable> {
    case loading
    case loaded(value: T)
    case failed(error: Swift.Error)
}

struct AlbumsView: View {
    @State private var viewState: ViewState<LazyAlbums> = .loading
    @State private var isAddViewVisible = false
    @State private var indexSetToDelete: IndexSet?

    let albums: LazyAlbums

    var body: some View {
        switch viewState {
        case .loading:
            ProgressView("Fetching media from \(albums.count) albums ...")
                .onAppear(perform: load)
        case let .loaded(albums):
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(0..<albums.count, id: \.self) { index in
                        if let album = albums[index], album.estimatedAssetCount > 0 {
                            NavigationLink(destination: AlbumView(album: album)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(album.localizedTitle ?? album.id)")
                                        Text("(estimated assets: \(album.estimatedAssetCount))").font(.footnote)
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
        // TODO: onDelete
//            .onDelete { indexSet in
//                indexSetToDelete = indexSet
//            }
    }
}

private extension AlbumsView {
    func load() {
        viewState = .loaded(value: albums)
    }

    func deleteConfirmationAlert(indexSetToDelete: IndexSet) -> Alert {
        var albumsToDelete: [LazyAlbum] = []
        for index in indexSetToDelete {
            guard index >= 0, index < albums.count else {
                continue
            }

            guard let album = albums[index] else {
                continue
            }
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
        AlbumsView(albums: LazyAlbums.cloud!)
    }
}
#endif
