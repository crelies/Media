//
//  CameraTests.swift
//  MediaTests
//
//  Created by Christian Elies on 17.12.19.
//

#if canImport(UIKit) && !os(tvOS)
@testable import MediaCore
@testable import MediaSwiftUI
import XCTest

final class CameraTests: XCTestCase {
    @available(iOS 13, *)
    func testView() {
        _ = Camera.view { _ in }
    }
}
#endif
