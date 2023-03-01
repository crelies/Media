//
//  AlbumView.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AlbumView: View {
    let album: Album

    var body: some View {
        VStack(spacing: 0) {
            Text("\(album.allMedia.count) media items").font(.footnote).padding(.vertical)

            List {
                if album.audios.count > 0 {
                    Section {
                        NavigationLink(destination: AudiosView(audios: album.audios)) {
                            Text("Audios (\(album.audios.count))")
                        }
                    }
                }

                if album.livePhotos.count > 0 {
                    Section {
                        NavigationLink(destination: LivePhotosView(livePhotos: album.livePhotos)) {
                            Text("Live Photos (\(album.livePhotos.count))")
                        }
                    }
                }

                if album.photos.count > 0 {
                    Section {
                        NavigationLink(destination: PhotosView(photos: album.photos)) {
                            Text("Photos (\(album.photos.count))")
                        }
                    }
                }

                if album.videos.count > 0 {
                    Section {
                        NavigationLink(destination: VideosView(videos: album.videos)) {
                            Text("Videos (\(album.videos.count))")
                        }
                    }
                }
            }
            .insetGroupedListStyle()
        }
        .universalInlineNavigationTitle(album.localizedTitle ?? "")
    }
}
