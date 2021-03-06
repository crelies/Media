//
//  LivePhotosView.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct LivePhotosView: View {
    let livePhotos: [LivePhoto]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<livePhotos.count, id: \.self) { index in
                    let livePhoto = livePhotos[index]
                    NavigationLink(destination: LivePhotoView(livePhoto: livePhoto)) {
                        HStack {
                            if let creationDate = livePhoto.metadata?.creationDate {
                                Text(creationDate, style: .date) + Text("\n(\(livePhoto.id.prefix(5).map(String.init).joined()))").font(.footnote)
                            } else {
                                Text(livePhoto.id)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
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
        .navigationBarTitle("Live Photos", displayMode: .inline)
    }
}
