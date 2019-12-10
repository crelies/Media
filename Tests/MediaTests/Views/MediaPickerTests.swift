//
//  MediaPickerTests.swift
//  MediaTests
//
//  Created by Christian Elies on 10.12.19.
//

@testable import Media
import SwiftUI
import XCTest

@available(iOS 13, macOS 10.15, tvOS 13, *)
final class MediaPickerTests: XCTestCase {
    override func setUp() {
        MediaPicker.imagePickerControllerType = MockUIImagePickerController.self
        MockUIImagePickerController.availableMediaTypesToReturn = [CFString.image as String]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeUIViewController() {
        let selection: (MediaPickerValue) -> Void = { value in }
        let mediaPicker = MediaPicker(sourceType: .photoLibrary,
                                      mediaTypes: [],
                                      onSelection: selection)
    }
}
