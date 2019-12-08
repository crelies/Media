//
//  ViewCreatorTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

@available(iOS 13, macOS 10.15, *)
final class ViewCreatorTests: XCTestCase {
    func testCreateCameraView() {
        do {
            let completion: (Result<URL, Error>) -> Void = { result in }
            _ = try ViewCreator.camera(for: [], completion)
            XCTFail("This should never happen because the simulator has no camera.")
        } catch {
            let cameraError = error as? CameraError
            XCTAssertEqual(cameraError, .noCameraAvailable)
        }
    }

    func testCreateBrowserView() {
        do {
            let completion: (Result<Photo, Error>) -> Void = { result in }
            _ = try ViewCreator.browser(mediaTypes: [], completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
