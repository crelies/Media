//
//  Video+PropertiesTests.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

import AVFoundation
@testable import MediaCore
import XCTest

final class Video_PropertiesTests: XCTestCase {
    func testCompleteInit() {
        let locationString = "MockLocation"
        let locationItem = MockAVMetadataItem()
        locationItem.commonKeyToReturn = .commonKeyLocation
        locationItem.stringValueToReturn = locationString

        let makeString = "Apple"
        let makeItem = MockAVMetadataItem()
        makeItem.commonKeyToReturn = .commonKeyMake
        makeItem.stringValueToReturn = makeString

        let modelString = "iPhone"
        let modelItem = MockAVMetadataItem()
        modelItem.commonKeyToReturn = .commonKeyModel
        modelItem.stringValueToReturn = modelString

        let softwareString = "iOS"
        let softwareItem = MockAVMetadataItem()
        softwareItem.commonKeyToReturn = .commonKeySoftware
        softwareItem.stringValueToReturn = softwareString

        let creationDate = Date()
        let creationDateItem = MockAVMetadataItem()
        creationDateItem.commonKeyToReturn = .commonKeyCreationDate
        creationDateItem.dateValueToReturn = creationDate

        let metadata: [AVMetadataItem] = [
            locationItem,
            makeItem,
            modelItem,
            softwareItem,
            creationDateItem
        ]
        let properties = Video.Properties(metadata: metadata)

        XCTAssertEqual(properties.location, locationItem.stringValue)
        XCTAssertEqual(properties.make, makeItem.stringValue)
        XCTAssertEqual(properties.model, modelItem.stringValue)
        XCTAssertEqual(properties.software, softwareItem.stringValue)
        XCTAssertEqual(properties.creationDate, creationDateItem.dateValue)
    }

    func testPartialInit() {
        let softwareString = "iOS"
        let softwareItem = MockAVMetadataItem()
        softwareItem.commonKeyToReturn = .commonKeySoftware
        softwareItem.stringValueToReturn = softwareString

        let properties = Video.Properties(metadata: [softwareItem])

        XCTAssertEqual(properties.software, softwareItem.stringValue)
    }

    func testEmptyInit() {
        let properties = Video.Properties(metadata: [])
        XCTAssertNil(properties.location)
        XCTAssertNil(properties.make)
        XCTAssertNil(properties.model)
        XCTAssertNil(properties.software)
        XCTAssertNil(properties.creationDate)
    }
}
