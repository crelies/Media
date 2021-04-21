//
//  AudiosView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct AudiosView: View {
    let audios: LazyAudios

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(0..<audios.count, id: \.self) { index in
                    if let audio = audios[index] {
                        (Text(audio.id) + Text("\n(\(audio.id.prefix(5).map(String.init).joined()))").font(.footnote))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Audios", displayMode: .inline)
    }
}
