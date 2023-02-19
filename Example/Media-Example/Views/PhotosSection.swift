//
//  PhotosSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

// TODO: macOS
struct PhotosSection: View {
    var body: some View {
        Section(header: Label("Photos", systemImage: "photo")) {
            #if !os(macOS)
            Group {
                let allPhotos = Media.Photos.all
                NavigationLink(destination: PhotosView(photos: allPhotos)) {
                    Text("Media.Photos.all (\(allPhotos.count))")
                }

                let livePhotos = Media.Photos.live
                NavigationLink(destination: LivePhotosView(livePhotos: livePhotos)) {
                    Text("Media.Photos.live (\(livePhotos.count))")
                }

                let depthEffectPhotos = Media.Photos.depthEffect
                NavigationLink(destination: PhotosView(photos: depthEffectPhotos)) {
                    Text("Media.Photos.depthEffect (\(depthEffectPhotos.count))")
                }

                let hdrPhotos = Media.Photos.hdr
                NavigationLink(destination: PhotosView(photos: hdrPhotos)) {
                    Text("Media.Photos.hdr (\(hdrPhotos.count))")
                }

                let panoramaPhotos = Media.Photos.panorama
                NavigationLink(destination: PhotosView(photos: panoramaPhotos)) {
                    Text("Media.Photos.panorama (\(panoramaPhotos.count))")
                }

                let screenshotPhotos = Media.Photos.screenshot
                NavigationLink(destination: PhotosView(photos: screenshotPhotos)) {
                    Text("Media.Photos.screenshot (\(screenshotPhotos.count))")
                }
            }
            #endif

            Group {
                #if !os(macOS)
                if let lazyAllPhotos = Media.LazyPhotos.all {
                    NavigationLink(destination: LazyPhotosView(photos: lazyAllPhotos)) {
                        Text("Media.LazyPhotos.all (\(lazyAllPhotos.count))")
                    }
                }
                #endif

                if let lazyLivePhotos = Media.LazyPhotos.live {
                    NavigationLink(destination: LazyLivePhotosView(livePhotos: lazyLivePhotos)) {
                        Text("Media.LazyPhotos.live (\(lazyLivePhotos.count))")
                    }
                }

                #if !os(macOS)
                if let lazyDepthEffectPhotos = Media.LazyPhotos.depthEffect {
                    NavigationLink(destination: LazyPhotosView(photos: lazyDepthEffectPhotos)) {
                        Text("Media.LazyPhotos.depthEffect (\(lazyDepthEffectPhotos.count))")
                    }
                }

                if let lazyHdrPhotos = Media.LazyPhotos.hdr {
                    NavigationLink(destination: LazyPhotosView(photos: lazyHdrPhotos)) {
                        Text("Media.LazyPhotos.hdr (\(lazyHdrPhotos.count))")
                    }
                }

                if let lazyPanoramaPhotos = Media.LazyPhotos.panorama {
                    NavigationLink(destination: LazyPhotosView(photos: lazyPanoramaPhotos)) {
                        Text("Media.LazyPhotos.panorama (\(lazyPanoramaPhotos.count))")
                    }
                }

                if let lazyScreenshotPhotos = Media.LazyPhotos.screenshot {
                    NavigationLink(destination: LazyPhotosView(photos: lazyScreenshotPhotos)) {
                        Text("Media.LazyPhotos.screenshot (\(lazyScreenshotPhotos.count))")
                    }
                }
                #endif
            }
        }
    }
}
