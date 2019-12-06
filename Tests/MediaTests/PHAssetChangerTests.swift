//
//  PHAssetChangerTests.swift
//  MediaTests
//
//  Created by Christian Elies on 06.12.19.
//

@testable import Media
import XCTest

@available(macOS 10.15, *)
final class PHAssetChangerTests: XCTestCase {
    override func setUp() {
        PHAssetChanger.photoLibrary = MockPhotoLibrary.self
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
    }
}
