//
//  ExampleApp.swift
//  Media-Example
//
//  Created by Christian Elies on 19.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import AVFoundation
import MediaCore
import MediaSwiftUI
import SwiftUI

#if !os(tvOS)
let cameraViewModel: CameraViewModel = try! CameraViewModel.make { result in
    guard let livePhotoData = try? result.get() else {
        return
    }

    try? LivePhoto.save(data: livePhotoData) { result in
        switch result {
        case .failure(let error):
            debugPrint("Live photo save error: \(error)")
        default: ()
        }
    }
}
#endif

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(cameraViewModel: cameraViewModel)
        }
    }

    init() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
}
