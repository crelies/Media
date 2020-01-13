//
//  AlbumFilterTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

@available(macOS 10.15, *)
final class AlbumFilterTests: XCTestCase {
    func testLocalIdentifierPredicate() {
        let localIdentifier = "MockIdentifier"
        let albumFilter: Album.Filter = .localIdentifier(localIdentifier)
        let expectedPredicate = NSPredicate(format: "localIdentifier = %@", localIdentifier)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testLocalizedTitlePredicate() {
        let localizedTitle = "MockLocalizedTitle"
        let albumFilter: Album.Filter = .localizedTitle(localizedTitle)
        let expectedPredicate = NSPredicate(format: "localizedTitle = %@", localizedTitle)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testTitlePredicate() {
        let title = "MockTitle"
        let albumFilter: Album.Filter = .title(title)
        let expectedPredicate = NSPredicate(format: "title = %@", title)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testStartDatePredicate() {
        let startDate = Date()
        let albumFilter: Album.Filter = .startDate(startDate)
        let expectedPredicate = NSPredicate(format: "startDate = %@", startDate as NSDate)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testEndDatePredicate() {
        let endDate = Date()
        let albumFilter: Album.Filter = .endDate(endDate)
        let expectedPredicate = NSPredicate(format: "endDate = %@", endDate as NSDate)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }

    func testEstimatedAssetCountPredicate() {
        let estimatedAssetCount = 5
        let albumFilter: Album.Filter = .estimatedAssetCount(estimatedAssetCount)
        let expectedPredicate = NSPredicate(format: "estimatedAssetCount = %i", estimatedAssetCount)
        XCTAssertEqual(albumFilter.predicate, expectedPredicate)
    }
}
