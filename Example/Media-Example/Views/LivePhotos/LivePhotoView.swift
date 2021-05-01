//
//  LivePhotoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import Photos
import SwiftUI

struct LivePhotoView: View {
    let livePhoto: LivePhoto

    var body: some View {
        #if os(macOS) || targetEnvironment(macCatalyst)
        Text("Live Photo objects are available only when editing Live Photo content in a photo editing extension that runs in the Photos app.")
            .padding(.horizontal)
        #else
        livePhoto.view(size: CGSize(width: 400, height: 200))
        #endif
    }
}
