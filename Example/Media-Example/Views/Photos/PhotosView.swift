//
//  PhotosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct PhotosView: View {
    let photos: Media.LazyPhotos

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<photos.count, id: \.self) { index in
                    if let photo = photos[index] {
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
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Photos", displayMode: .inline)
    }
}
