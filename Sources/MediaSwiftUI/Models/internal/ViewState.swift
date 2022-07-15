//
//  ViewState.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 14.02.21.
//

import Foundation

enum ViewState<T: Equatable> {
    case loading
    case loaded(value: T)
    case failed(error: Swift.Error)
}

extension ViewState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded(let leftValue), .loaded(let rightValue)):
            return leftValue == rightValue
        case (.failed(let leftError as NSError), .failed(let rightError as NSError)):
            return leftError == rightError
        default:
            return false
        }
    }
}
