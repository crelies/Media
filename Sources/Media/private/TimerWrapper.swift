//
//  TimerWrapper.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Foundation

typealias TimerFiredClosure = (Timer) -> Void

final class TimerWrapper {
    private let timeInterval: TimeInterval
    private let repeats: Bool
    private let timerFiredClosure: TimerFiredClosure

    private(set) lazy var timer: Timer = {
        Timer(timeInterval: timeInterval,
              target: self,
              selector: #selector(timerFired(_:)),
              userInfo: nil,
              repeats: repeats)
    }()

    init(timeInterval: TimeInterval,
         repeats: Bool,
         _ timerFiredClosure: @escaping TimerFiredClosure) {
        self.timeInterval = timeInterval
        self.repeats = repeats
        self.timerFiredClosure = timerFiredClosure
    }
}

extension TimerWrapper {
    @objc private func timerFired(_ timer: Timer) {
        timerFiredClosure(timer)
    }
}
