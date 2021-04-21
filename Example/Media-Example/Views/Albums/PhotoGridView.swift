//
//  PhotoGridView.swift
//  Media-Example
//
//  Created by Christian Elies on 14.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct PhotoGridView: View {
    let photos: Media.LazyPhotos

    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(0..<photos.count, id: \.self) { index in
                    if let photo = photos[index] {
                        photo.view(targetSize: .init(width: 200, height: 200)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            })
        }
    }
}
