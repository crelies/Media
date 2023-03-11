//
//  LazyAlbumsView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct LazyAlbumsView: View {
    @State private var viewState: ViewState<LazyAlbums> = .loading
    @State private var isAddViewVisible = false

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
                            NavigationLink(destination: LazyAlbumView(album: album)) {
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
                            .secondarySystemBackground()
                            .cornerRadius(16)
                        }
                    }
                }
                .padding()
            }
            .insetGroupedListStyle()
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
        case let .failed(error):
            Text(error.localizedDescription)
        }
    }
}

private extension LazyAlbumsView {
    func load() {
        viewState = .loaded(value: albums)
    }
}

struct LazyAlbumsView_Previews: PreviewProvider {
    static var previews: some View {
        LazyAlbumsView(albums: LazyAlbums.cloud!)
    }
}
