//
//  CameraTests.swift
//  MediaTests
//
//  Created by Christian Elies on 17.12.19.
//

@testable import Media
import XCTest

final class CameraTests: XCTestCase {
    @available(iOS 13, *)
    func testView() {
        do {
            _ = try Camera.view { _ in }
            XCTFail("This should never happen because the simulator has no camera.")
        } catch {
            XCTAssertEqual(error as? CameraError, .noCameraAvailable)
        }
    }
}
