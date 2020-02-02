//
//  MockAVCaptureResolvedPhotoSettings.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

import AVFoundation

@available(iOS 10, *)
final class MockAVCaptureResolvedPhotoSettings: AVCaptureResolvedPhotoSettings {
    private let id: String

    init(id: String = UUID().uuidString) {
        self.id = id
    }
}
