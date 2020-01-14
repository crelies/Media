//
//  Video+ExportOptionsTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import Media
import XCTest

@available(macOS 10.15, *)
final class Video_ExportOptionsTests: XCTestCase {
    func testInit() {
        do {
            let url = URL(fileURLWithPath: "file://test.mov")
            let mediaURL = try MediaURL<Video>(url: url)
            _ = Video.ExportOptions(url: mediaURL, quality: .low)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
