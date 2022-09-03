//
//  LazyAlbumView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct LazyAlbumView: View {
    let album: LazyAlbum

    var body: some View {
        VStack(spacing: 0) {
            Text("\(album.estimatedAssetCount) estimated media items").font(.footnote).padding(.vertical)

            List {
                if let audios = album.audios, audios.count > 0 {
                    Section {
                        NavigationLink(destination: LazyAudiosView(audios: audios)) {
                            Text("Audios (\(audios.count))")
                        }
                    }
                }

                if let livePhotos = album.livePhotos, livePhotos.count > 0 {
                    Section {
                        NavigationLink(destination: LazyLivePhotosView(livePhotos: livePhotos)) {
                            Text("Live Photos (\(livePhotos.count))")
                        }
                    }
                }

                if let photos = album.photos, photos.count > 0 {
                    Section {
                        NavigationLink(destination: LazyPhotosView(photos: photos)) {
                            Text("Photos (\(photos.count))")
                        }
                    }

                    Section {
                        NavigationLink(destination: LazyPhotoGridView(photos: photos)) {
                            Text("Photo GridView")
                        }
                    }
                }

                if let videos = album.videos, videos.count > 0 {
                    Section {
                        NavigationLink(destination: LazyVideosView(videos: videos)) {
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
