//
//  AlbumFilterTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

final class AlbumFilterTests: XCTestCase {
    func testLocalIdentifierPredicate() {
        let localIdentifier = "MockIdentifier"
        let albumFilter: AlbumFilter = .localIdentifier(localIdentifier)
        let expectedPredicate = NSPredicate(format: "localIdentifier = %@", localIdentifier)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testLocalizedTitlePredicate() {
        let localizedTitle = "MockLocalizedTitle"
        let albumFilter: AlbumFilter = .localizedTitle(localizedTitle)
        let expectedPredicate = NSPredicate(format: "localizedTitle = %@", localizedTitle)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testTitlePredicate() {
        let title = "MockTitle"
        let albumFilter: AlbumFilter = .title(title)
        let expectedPredicate = NSPredicate(format: "title = %@", title)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testStartDatePredicate() {
        let startDate = Date()
        let albumFilter: AlbumFilter = .startDate(startDate)
        let expectedPredicate = NSPredicate(format: "startDate = %@", startDate as NSDate)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testEndDatePredicate() {
        let endDate = Date()
        let albumFilter: AlbumFilter = .endDate(endDate)
        let expectedPredicate = NSPredicate(format: "endDate = %@", endDate as NSDate)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testEstimatedAssetCountPredicate() {
        let estimatedAssetCount = 5
        let albumFilter: AlbumFilter = .estimatedAssetCount(estimatedAssetCount)
        let expectedPredicate = NSPredicate(format: "estimatedAssetCount = %i", estimatedAssetCount)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }
}
