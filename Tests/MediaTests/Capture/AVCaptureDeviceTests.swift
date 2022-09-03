//
//  AVCaptureDeviceTests.swift
//  MediaTests
//
//  Created by Christian Elies on 02.02.20.
//

#if !os(tvOS)
import AVFoundation
@testable import MediaCore
import XCTest

@available(iOS 13, *)
final class AVCaptureDeviceTests: XCTestCase {
    func testBackVideoCamera() {
        do {
            _ = try AVCaptureDevice.videoCamera()
            XCTFail("Simulator has no camera")
        } catch {
            // "success", do nothing
        }
    }
}
#endif
