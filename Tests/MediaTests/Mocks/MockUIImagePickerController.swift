//
//  MockUIImagePickerController.swift
//  MediaTests
//
//  Created by Christian Elies on 10.12.19.
//

#if canImport(UIKit) && !os(tvOS)
import UIKit

final class MockUIImagePickerController: UIImagePickerController {
    static var availableMediaTypesToReturn: [String] = []

    override class func availableMediaTypes(for sourceType: UIImagePickerController.SourceType) -> [String]? {
        availableMediaTypesToReturn
    }
}
#endif
