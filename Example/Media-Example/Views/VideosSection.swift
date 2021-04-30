//
//  VideosSection.swift
//  Media-Example
//
//  Created by Christian Elies on 22.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import MediaCore
import SwiftUI

struct VideosSection: View {
    var body: some View {
        Section {
            if let lazyAllVideos = LazyVideos.all {
                NavigationLink(destination: LazyVideosView(videos: lazyAllVideos)) {
                    Text("LazyVideos.all (\(lazyAllVideos.count))")
                }
            }

            let allVideos = Videos.all
            NavigationLink(destination: VideosView(videos: allVideos)) {
                Text("Videos.all (\(allVideos.count))")
            }

            if let lazyHighFrameRatesVideos = LazyVideos.highFrameRates {
                NavigationLink(destination: LazyVideosView(videos: lazyHighFrameRatesVideos)) {
                    Text("LazyVideos.highFrameRates (\(lazyHighFrameRatesVideos.count))")
                }
            }

            let highFrameRatesVideos = Videos.highFrameRates
            NavigationLink(destination: VideosView(videos: highFrameRatesVideos)) {
                Text("Videos.highFrameRates (\(highFrameRatesVideos.count))")
            }

            if let lazyStreamsVideos = LazyVideos.streams {
                NavigationLink(destination: LazyVideosView(videos: lazyStreamsVideos)) {
                    Text("LazyVideos.streams (\(lazyStreamsVideos.count))")
                }
            }

            let streamsVideos = Videos.streams
            NavigationLink(destination: VideosView(videos: streamsVideos)) {
                Text("Videos.streams (\(streamsVideos.count))")
            }

            if let lazyTimelapsesVideos = LazyVideos.timelapses {
                NavigationLink(destination: LazyVideosView(videos: lazyTimelapsesVideos)) {
                    Text("LazyVideos.timelapses (\(lazyTimelapsesVideos.count))")
                }
            }

            let timelapsesVideos = Videos.timelapses
            NavigationLink(destination: VideosView(videos: timelapsesVideos)) {
                Text("Videos.timelapses (\(timelapsesVideos.count))")
            }
        }
    }
}
