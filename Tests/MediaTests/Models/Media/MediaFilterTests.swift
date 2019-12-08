//
//  MediaFilterTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class MediaFilterTests: XCTestCase {
    func testLocalIdentifierPredicate() {
        let localIdentifier = "MockLocalIdentifier"
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .localIdentifier(localIdentifier)
        let expectedPredicate = NSPredicate(format: "localIdentifier = %@", localIdentifier)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testCreationDatePredicate() {
        let creationDate = Date()
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .creationDate(creationDate)
        let expectedPredicate = NSPredicate(format: "creationDate = %@", creationDate as NSDate)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testModificationDatePredicate() {
        let modificationDate = Date()
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .modificationDate(modificationDate)
        let expectedPredicate = NSPredicate(format: "modificationDate = %@", modificationDate as NSDate)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testMediaSubtypesPredicate() {
        // TODO:
    }

    func testDurationPredicate() {
        let duration: TimeInterval = 500
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .duration(duration)
        let expectedPredicate = NSPredicate(format: "duration = %d", duration)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testPixelWidthPredicate() {
        let pixelWidth: Int = 500
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .pixelWidth(pixelWidth)
        let expectedPredicate = NSPredicate(format: "pixelWidth = %i", pixelWidth)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testPixelHeightPredicate() {
        let pixelHeight: Int = 500
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .pixelHeight(pixelHeight)
        let expectedPredicate = NSPredicate(format: "pixelHeight = %i", pixelHeight)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testIsFavoritePredicate() {
        let isFavorite = false
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .isFavorite(isFavorite)
        let expectedPredicate = NSPredicate(format: "isFavorite = %@", NSNumber(booleanLiteral: isFavorite))
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testIsHiddenPredicate() {
        let isHidden = false
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .isHidden(isHidden)
        let expectedPredicate = NSPredicate(format: "isHidden = %@", NSNumber(booleanLiteral: isHidden))
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testBurstIdentifierPredicate() {
        let burstIdentifier = "MockBurstIdentifier"
        let mediaFilter: MediaFilter<LivePhotoSubtype> = .burstIdentifier(burstIdentifier)
        let expectedPredicate = NSPredicate(format: "burstIdentifier = %@", burstIdentifier)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }
}
