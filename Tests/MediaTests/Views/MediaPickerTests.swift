//
//  MediaPickerTests.swift
//  MediaTests
//
//  Created by Christian Elies on 10.12.19.
//

#if canImport(UIKit) && !os(tvOS)
@testable import MediaSwiftUI
import SwiftUI
import XCTest

@available(iOS 13, macOS 10.15, tvOS 13, *)
final class MediaPickerTests: XCTestCase {
    override func setUp() {
        MediaPicker.imagePickerControllerType = MockUIImagePickerController.self
        MockUIImagePickerController.availableMediaTypesToReturn = [CFString.image as String]
    }

    func testInitPhotoLibraryMediaPicker() {
        let selection: (MediaPickerValue) -> Void = { _ in }
        let onFailure: (MediaPicker.Error) -> Void = { _ in }
        _ = MediaPicker(sourceType: .photoLibrary,
                        mediaTypes: [],
                        onSelection: selection,
                        onFailure: onFailure)
    }
}
#endif
