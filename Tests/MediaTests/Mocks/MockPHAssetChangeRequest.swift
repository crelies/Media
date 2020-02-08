//
//  MockPHAssetChangeRequest.swift
//  MediaTests
//
//  Created by Christian Elies on 12.12.19.
//

#if canImport(UIKit)
@testable import MediaCore
import Photos
import UIKit

final class MockPHAssetChangeRequest: AssetChangeRequest {
    var placeholderForCreatedAsset: PHObjectPlaceholder? { Self.placeholderForCreatedAssetToReturn }

    static var placeholderForCreatedAssetToReturn: MockPHObjectPlaceholder?

    static func creationRequestForAsset(from image: UIImage) -> Self {
        Self.init()
    }

    static func creationRequestForAssetFromImage(atFileURL fileURL: URL) -> Self? {
        Self.init()
    }
}
#endif
