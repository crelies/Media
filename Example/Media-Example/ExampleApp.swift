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
var livePhotoCaptureResult: Result<LivePhotoData, Error>?

var livePhotoCaptureBinding: Binding<Result<LivePhotoData, Error>?> = .init(
    get: { livePhotoCaptureResult },
    set: { livePhotoCaptureResult = $0 }
).onChange { result in
    guard let livePhotoData: LivePhotoData = try? result?.get() else {
        return
    }

    #if !targetEnvironment(macCatalyst)
    try? LivePhoto.save(data: livePhotoData) { result in
        switch result {
        case .failure(let error):
            debugPrint("Live photo save error: \(error)")
        default: ()
        }
    }
    #endif
}

let rootCameraViewModel: LivePhotoCameraViewModel = try! LivePhotoCameraViewModel.make(
    selection: livePhotoCaptureBinding
)
#endif

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            #if !os(tvOS)
            ContentView(cameraViewModel: rootCameraViewModel)
            #else
            ContentView()
            #endif
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
