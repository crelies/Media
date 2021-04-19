//
//  MockCaptureProcessorDelegate.swift
//  MediaTests
//
//  Created by Christian Elies on 08.02.20.
//

#if !os(tvOS)
import Foundation
@testable import MediaCore

@available(iOS 10, *)
final class MockCaptureProcessorDelegate: CaptureProcessorDelegate {
    private(set) var didCaptureLivePhotoCalled: Bool = false
    private(set) var didCapturePhotoCalled: Bool = false

    func didCaptureLivePhoto(data: LivePhotoData) {
        didCaptureLivePhotoCalled = true
    }

    func didCapturePhoto(data: Data) {
        didCapturePhotoCalled = true
    }

    func reset() {
        didCaptureLivePhotoCalled = false
        didCapturePhotoCalled = false
    }
}
#endif
