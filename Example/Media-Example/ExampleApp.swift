//
//  ExampleApp.swift
//  Media-Example
//
//  Created by Christian Elies on 19.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import AVFoundation
import SwiftUI

let dependencies = Dependencies()

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            #if !os(tvOS) && !os(macOS)
            ContentView(cameraViewModel: dependencies.photoCameraViewModel)
            #elseif os(macOS) && !targetEnvironment(macCatalyst)
            ContentView(
                cameraViewModel: dependencies.photoCameraViewModel,
                videoCameraViewModel: dependencies.videoCameraViewModel
            )
            #else
            ContentView()
            #endif
        }
    }

    #if !os(macOS)
    init() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    #endif
}
