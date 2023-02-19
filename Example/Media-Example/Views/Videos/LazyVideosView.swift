//
//  LazyVideosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct LazyVideosView: View {
    let videos: LazyVideos

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<videos.count, id: \.self) { index in
                    if let video = videos[index] {
                        NavigationLink(destination: VideoView(video: video)) {
                            HStack {
                                if let creationDate = video.metadata?.creationDate {
                                    Text(creationDate, style: .date) + Text("\n(\(video.id.prefix(5).map(String.init).joined()))").font(.footnote)
                                } else {
                                    Text(video.id)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding()
                            #if !os(tvOS) && !os(macOS)
                            .background(Color(.secondarySystemBackground))
                            #endif
                            .cornerRadius(16)
                        }
                    }
                }
            }
            .padding()
        }
        #if !os(tvOS) && !os(macOS)
        .navigationBarTitle("Videos", displayMode: .inline)
        #else
        .navigationTitle(Text("Videos"))
        #endif
    }
}
