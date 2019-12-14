//
//  AnyMedia+EquatableTests.swift
//  MediaTests
//
//  Created by Christian Elies on 14.12.19.
//

@testable import Media
import XCTest

final class AnyMedia_EquatableTests: XCTestCase {
    let asset = MockPHAsset()

    override func setUp() {
        asset.localIdentifierToReturn = UUID().uuidString
    }

    func testEqual() {
        let photo1 = Photo(phAsset: asset)
        let photo2 = Photo(phAsset: asset)
        let anyMedia1 = AnyMedia(photo1)
        let anyMedia2 = AnyMedia(photo2)
        XCTAssertEqual(anyMedia1, anyMedia2)
    }

    func testNotEqual() {
        let asset2 = MockPHAsset()
        asset2.localIdentifierToReturn = UUID().uuidString

        let photo1 = Photo(phAsset: asset)
        let photo2 = Photo(phAsset: asset2)
        let anyMedia1 = AnyMedia(photo1)
        let anyMedia2 = AnyMedia(photo2)
        XCTAssertNotEqual(anyMedia1, anyMedia2)
    }
}
