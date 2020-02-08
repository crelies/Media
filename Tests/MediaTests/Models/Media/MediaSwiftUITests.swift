//
//  MediaSwiftUITests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

#if canImport(UIKit) && !os(tvOS)
@testable import MediaCore
import Photos
import XCTest

@available(iOS 13, *)
final class MediaSwiftUITests: XCTestCase {
    func testBrowser() {
        do {
            let completion: ResultPHAssetCompletion = { result in }
            _ = try Media.browser(completion)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
#endif
