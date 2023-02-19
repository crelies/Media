//
//  AudiosView.swift
//  Media-Example
//
//  Created by Christian Elies on 01.05.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AudiosView: View {
    let audios: [Audio]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<audios.count, id: \.self) { index in
                    let audio = audios[index]
                    (Text(audio.id) + Text("\n(\(audio.id.prefix(5).map(String.init).joined()))").font(.footnote))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding()
                        #if !os(tvOS)
                        .background(Color(.secondarySystemBackground))
                        #endif
                        .cornerRadius(16)
                }
            }
            .padding()
        }
        #if !os(tvOS) && !os(macOS)
        .navigationBarTitle("Audios", displayMode: .inline)
        #else
        .navigationTitle(Text("Audios"))
        #endif
    }
}
