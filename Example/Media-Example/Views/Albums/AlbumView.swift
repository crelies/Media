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
                if let audios = album.audios, audios.count > 0 {
                    Section {
                        NavigationLink(destination: AudiosView(audios: audios)) {
                            Text("Audios (\(audios.count))")
                        }
                    }
                }

                if let livePhotos = album.livePhotos, livePhotos.count > 0 {
                    Section {
                        NavigationLink(destination: LivePhotosView(livePhotos: livePhotos)) {
                            Text("Live Photos (\(livePhotos.count))")
                        }
                    }
                }

                if let photos = album.photos, photos.count > 0 {
                    Section {
                        NavigationLink(destination: PhotosView(photos: photos)) {
                            Text("Photos (\(photos.count))")
                        }
                    }
                }

                if let videos = album.videos, videos.count > 0 {
                    Section {
                        NavigationLink(destination: VideosView(videos: videos)) {
                            Text("Videos (\(videos.count))")
                        }
                    }
                }
            }
            #if !os(tvOS)
            .listStyle(InsetGroupedListStyle())
            #endif
        }
        #if !os(tvOS)
        .navigationBarTitle(Text(album.localizedTitle ?? ""), displayMode: .inline)
        #else
        .navigationTitle(Text(album.localizedTitle ?? ""))
        #endif
    }
}
