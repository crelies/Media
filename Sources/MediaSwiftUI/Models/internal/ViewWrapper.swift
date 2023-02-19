//
//  ViewWrapper.swift
//  MediaSwiftUI
//
//  Created by Christian Elies on 15.02.20.
//

import SwiftUI

@available(iOS 13, macOS 10.15, tvOS 13, *)
final class ViewWrapper<T: View> {
    var value: T?
}
