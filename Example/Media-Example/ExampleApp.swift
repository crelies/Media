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
var livePhotoCaptureResult: Result<CapturedPhotoData, Error>?

var livePhotoCaptureBinding: Binding<Result<CapturedPhotoData, Error>?> = .init(
    get: { livePhotoCaptureResult },
    set: { livePhotoCaptureResult = $0 }
).onChange { result in
    guard let capturedPhotoData: CapturedPhotoData = try? result?.get() else {
        return
    }

    #if !targetEnvironment(macCatalyst) && !os(macOS)
    LivePhoto.save(data: capturedPhotoData) { result in
        switch result {
        case .failure(let error):
            debugPrint("Live photo save error: \(error)")
        default: ()
        }
    }
    #endif
}

let rootCameraViewModel: PhotoCameraViewModel = try! PhotoCameraViewModel.make(
    selection: livePhotoCaptureBinding
)

#if os(macOS)
let rootVideoCameraViewModel: VideoCameraViewModel = try! VideoCameraViewModel.make(
    selection: livePhotoCaptureBinding
)
#endif

#endif

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            #if !os(tvOS) && !os(macOS)
            ContentView(cameraViewModel: rootCameraViewModel)
            #elseif os(macOS) && !targetEnvironment(macCatalyst)
            ContentView(cameraViewModel: rootCameraViewModel, videoCameraViewModel: rootVideoCameraViewModel)
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
