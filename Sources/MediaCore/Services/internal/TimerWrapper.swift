//
//  TimerWrapper.swift
//  MediaCore
//
//  Created by Christian Elies on 01.12.19.
//

import Foundation

final class TimerWrapper {
    typealias TimerFiredClosure = (Timer) -> Void

    private let timeInterval: TimeInterval
    private let repeats: Bool
    private let timerFiredClosure: TimerFiredClosure

    private(set) lazy var timer: Timer = {
        Timer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(timerFired(_:)),
            userInfo: nil,
            repeats: repeats
        )
    }()

    init(
        timeInterval: TimeInterval,
        repeats: Bool,
        _ timerFiredClosure: @escaping TimerFiredClosure
    ) {
        self.timeInterval = timeInterval
        self.repeats = repeats
        self.timerFiredClosure = timerFiredClosure
    }
}

private extension TimerWrapper {
    @objc
    func timerFired(_ timer: Timer) {
        timerFiredClosure(timer)
    }
}
