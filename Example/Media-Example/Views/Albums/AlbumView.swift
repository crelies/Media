//
//  AlbumView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AlbumView: View {
    let album: LazyAlbum

    var body: some View {
        VStack(spacing: 0) {
            Text("\(album.estimatedAssetCount) estimated media items").font(.footnote).padding(.vertical)

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

                    Section {
                        NavigationLink(destination: PhotoGridView(photos: photos)) {
                            Text("Photo GridView")
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
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle(Text(album.localizedTitle ?? ""), displayMode: .inline)
    }
}
