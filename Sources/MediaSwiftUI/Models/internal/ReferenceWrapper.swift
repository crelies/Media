//
//  ReferenceWrapper.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15.02.21.
//

import Foundation

final class ReferenceWrapper<T: AnyObject> {
    var value: T

    init(value: T) {
        self.value = value
    }
}
