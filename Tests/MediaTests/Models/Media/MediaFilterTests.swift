//
//  MediaFilterTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import MediaCore
import XCTest

final class MediaFilterTests: XCTestCase {
    func testLocalIdentifierPredicate() {
        let localIdentifier = "MockLocalIdentifier"
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .localIdentifier(localIdentifier)
        let expectedPredicate = NSPredicate(format: "localIdentifier = %@", localIdentifier)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testCreationDatePredicate() {
        let creationDate = Date()
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .creationDate(creationDate)
        let expectedPredicate = NSPredicate(format: "creationDate = %@", creationDate as NSDate)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testModificationDatePredicate() {
        let modificationDate = Date()
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .modificationDate(modificationDate)
        let expectedPredicate = NSPredicate(format: "modificationDate = %@", modificationDate as NSDate)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testMediaSubtypesPredicate() {
        // TODO: implement test
    }

    func testDurationPredicate() {
        let duration: TimeInterval = 500
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .duration(duration)
        let expectedPredicate = NSPredicate(format: "duration = %d", duration)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testPixelWidthPredicate() {
        let pixelWidth: Int = 500
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .pixelWidth(pixelWidth)
        let expectedPredicate = NSPredicate(format: "pixelWidth = %i", pixelWidth)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testPixelHeightPredicate() {
        let pixelHeight: Int = 500
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .pixelHeight(pixelHeight)
        let expectedPredicate = NSPredicate(format: "pixelHeight = %i", pixelHeight)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testIsFavoritePredicate() {
        let isFavorite = false
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .isFavorite(isFavorite)
        let expectedPredicate = NSPredicate(format: "isFavorite = %@", NSNumber(booleanLiteral: isFavorite))
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testIsHiddenPredicate() {
        let isHidden = false
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .isHidden(isHidden)
        let expectedPredicate = NSPredicate(format: "isHidden = %@", NSNumber(booleanLiteral: isHidden))
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }

    func testBurstIdentifierPredicate() {
        let burstIdentifier = "MockBurstIdentifier"
        let mediaFilter: Media.Filter<LivePhoto.Subtype> = .burstIdentifier(burstIdentifier)
        let expectedPredicate = NSPredicate(format: "burstIdentifier = %@", burstIdentifier)
        XCTAssertEqual(mediaFilter.predicate, expectedPredicate)
    }
}
