import XCTest
@testable import Media

final class MediaTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Media().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
