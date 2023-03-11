//
//  PhotosView.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct PhotosView: View {
    let photos: [Photo]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<photos.count, id: \.self) { index in
                    let photo = photos[index]
                    NavigationLink(destination: PhotoView(photo: photo)) {
                        HStack {
                            if let creationDate = photo.metadata?.creationDate {
                                Text(creationDate, style: .date) + Text("\n(\(photo.id.prefix(5).map(String.init).joined()))").font(.footnote)
                            } else {
                                Text(photo.id)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
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
        .universalInlineNavigationTitle("Photos")
    }
}
