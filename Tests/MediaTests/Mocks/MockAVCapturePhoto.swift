//
//  MockAVCapturePhoto.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

import AVFoundation

@available(iOS 11, *)
final class MockAVCapturePhoto: AVCapturePhoto {
    private let id: String

    var fileDataRepresentationData: Data?

    init(id: String = UUID().uuidString) {
        self.id = id
    }

    override func fileDataRepresentation() -> Data? {
        fileDataRepresentationData
    }
}
