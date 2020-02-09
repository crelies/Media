//
//  MockAVMetadataItem.swift
//  MediaTests
//
//  Created by Christian Elies on 09.02.20.
//

import AVFoundation

final class MockAVMetadataItem: AVMetadataItem {
    var commonKeyToReturn: AVMetadataKey?
    var stringValueToReturn: String?
    var dateValueToReturn: Date?

    override var commonKey: AVMetadataKey? { commonKeyToReturn }
    override var stringValue: String? { stringValueToReturn }
    override var dateValue: Date? { dateValueToReturn }
}
