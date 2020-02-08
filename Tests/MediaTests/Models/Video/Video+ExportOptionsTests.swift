//
//  Video+ExportOptionsTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import MediaCore
import XCTest

final class Video_ExportOptionsTests: XCTestCase {
    func testInit() {
        do {
            let url = URL(fileURLWithPath: "file://test.mov")
            let mediaURL = try Media.URL<Video>(url: url)
            #if os(macOS)
            let quality: Video.ExportQualityMac = .cellular
            #else
            let quality: Video.ExportQuality = .low
            #endif
            _ = Video.ExportOptions(url: mediaURL, quality: quality)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
