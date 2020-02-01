//
//  AnyMediaTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import XCTest

final class AnyMediaTests: XCTestCase {
    func testInitialization() {
        let asset = MockPHAsset()
        let photo = Photo(phAsset: asset)
        let anyMedia = AnyMedia(photo)

        guard let photoIdentifier = photo.identifier else {
            XCTFail("Missing photo identifier")
            return
        }
        
        let expectedIdentifier = AnyMedia.Identifier(photoIdentifier)
        XCTAssertEqual(anyMedia?.identifier, expectedIdentifier)
        XCTAssertNotNil(anyMedia?.value as? Photo)
    }
}
