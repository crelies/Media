//
//  MediaSwiftUITests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

#if canImport(UIKit) && !os(tvOS)
import MediaCore
import MediaSwiftUI
import Photos
import XCTest

@available(iOS 13, *)
final class MediaSwiftUITests: XCTestCase {
    func testBrowser() {
        let completion: ResultPHAssetsCompletion = { result in }
        _ = Media.browser(isPresented: .constant(true), completion)
    }
}
#endif
