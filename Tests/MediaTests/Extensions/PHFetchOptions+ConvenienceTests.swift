//
//  PHFetchOptions+ConvenienceTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import Photos
import XCTest

final class PHFetchOptions_ConvenienceTests: XCTestCase {
    func testPredicate() {
        let options = PHFetchOptions()
        let localIdentifier = "Test"
        let predicate = NSPredicate(format: "localIdentifier = %@", localIdentifier)
        XCTAssertEqual(options.predicate(predicate), options)
        XCTAssertEqual(options.predicate, predicate)
    }

    func testFetchLimit() {
        let options = PHFetchOptions()
        let fetchLimit: Int = 5
        XCTAssertEqual(options.fetchLimit(fetchLimit), options)
        XCTAssertEqual(options.fetchLimit, 5)
    }

    func testSortDescriptors() {
        let options = PHFetchOptions()
        let sortDescriptors = [NSSortDescriptor(key: "localIdentifier", ascending: false)]
        XCTAssertEqual(options.sortDescriptors(sortDescriptors), options)
        XCTAssertEqual(options.sortDescriptors, sortDescriptors)
    }
}
