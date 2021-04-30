//
//  PhotosSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct PhotosSection: View {
    var body: some View {
        Section {
            if let allPhotos = Media.LazyPhotos.all {
                NavigationLink(destination: LazyPhotosView(photos: allPhotos)) {
                    Text("Media.Photos.all (\(allPhotos.count))")
                }
            }

            if let livePhotos = Media.LazyPhotos.live {
                NavigationLink(destination: LazyLivePhotosView(livePhotos: livePhotos)) {
                    Text("Media.Photos.live (\(livePhotos.count))")
                }
            }

            if let depthEffectPhotos = Media.LazyPhotos.depthEffect {
                NavigationLink(destination: LazyPhotosView(photos: depthEffectPhotos)) {
                    Text("Photos.depthEffect (\(depthEffectPhotos.count))")
                }
            }

            if let hdrPhotos = Media.LazyPhotos.hdr {
                NavigationLink(destination: LazyPhotosView(photos: hdrPhotos)) {
                    Text("Photos.hdr (\(hdrPhotos.count))")
                }
            }

            if let panoramaPhotos = Media.LazyPhotos.panorama {
                NavigationLink(destination: LazyPhotosView(photos: panoramaPhotos)) {
                    Text("Photos.panorama (\(panoramaPhotos.count))")
                }
            }

            if let screenshotPhotos = Media.LazyPhotos.screenshot {
                NavigationLink(destination: LazyPhotosView(photos: screenshotPhotos)) {
                    Text("Photos.screenshot (\(screenshotPhotos.count))")
                }
            }
        }
    }
}
