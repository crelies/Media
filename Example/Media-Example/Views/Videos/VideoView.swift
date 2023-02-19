//
//  VideoView.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import AVFoundation
import MediaCore
import MediaSwiftUI
import Photos
import SwiftUI

#if canImport(UIKit)
import UIKit

private struct ActivityIndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
#endif

struct VideoView: View {
    private enum PreviewImageState {
        case loading
        case loaded(image: UniversalImage?)
    }

    private static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }()

    @State private var previewImageState: PreviewImageState = .loading
    @State private var exportSuccessful: Bool?
    @State private var progress: Float = 0
    @State private var isPlayerPresented = false

    private var progressView: some View {
        #if !os(macOS)
        ActivityIndicatorView()
        #else
        ProgressView()
        #endif
    }

    let video: Video

    var body: some View {
        switch previewImageState {
        case .loading:
            progressView
                .onAppear {
                    video.previewImage { result in
                        let previewImage = try? result.get()
                        previewImageState = .loaded(image: previewImage)
                    }
                }
        case let .loaded(previewImage):
            VStack {
                Text(video.subtypes.map { String(describing: $0) }.joined(separator: ", ")).font(.headline)

                ZStack {
                    if let previewImage = previewImage {
                        Image(universalImage: previewImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    Button {
                        isPlayerPresented = true
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            #if !os(macOS)
                            .foregroundColor(Color(.secondaryLabel))
                            #endif
                    }
                    .sheet(isPresented: $isPlayerPresented) {
                        isPlayerPresented = false
                    } content: {
                        video.view
                            .universalNavigationBarItems(trailing: VStack(spacing: 8) {
                                Button(action: export) {
                                    Text("Export")
                                        .foregroundColor(exportSuccessful == nil ? Color(.systemBlue) : ((exportSuccessful ?? true) ? Color(.systemGreen) : Color(.systemRed)))
                                }

                                if progress > 0 {
                                    ProgressView(value: progress, total: 1)
                                }
                            })
                    }
                }
            }
            .padding()
        }
    }
}

private extension VideoView {
    var videoExportQuality: VideoExportQualityType {
        #if os(macOS)
        return .cellular
        #else
        return .low
        #endif
    }

    func export() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let fileURL = url.appendingPathComponent("\(UUID().uuidString).mov")
        guard let outputURL = try? Media.URL<Video>(url: fileURL) else {
            return
        }

        let exportOptions = Video.ExportOptions(url: outputURL, quality: videoExportQuality)

        exportSuccessful = nil
        progress = 0
        video.export(exportOptions, progress: { progress in
            switch progress {
            case .completed:
                self.progress = 0
            case .pending(let value):
                self.progress = value
            }
        }) { result in
            switch result {
            case .success:
                progress = 0
                exportSuccessful = true
            case .failure:
                progress = 0
                exportSuccessful = false
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(video: .init(phAsset: PHAsset()))
    }
}
