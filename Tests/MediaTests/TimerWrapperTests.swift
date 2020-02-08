//
//  TimerWrapperTests.swift
//  MediaTests
//
//  Created by Christian Elies on 08.12.19.
//

@testable import MediaCore
import XCTest

final class TimerWrapperTests: XCTestCase {
    func testTimerFired() {
        let expectation = self.expectation(description: "TimerFired")

        var timerFired = false
        let timerWrapper = TimerWrapper(timeInterval: 1, repeats: true) { timer in
            timerFired = true
            timer.invalidate()
            expectation.fulfill()
        }
        RunLoop.main.add(timerWrapper.timer, forMode: .common)

        waitForExpectations(timeout: 2)

        XCTAssertTrue(timerFired)
    }
}
