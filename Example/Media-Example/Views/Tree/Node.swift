//
//  Node.swift
//  Media-Example
//
//  Created by Christian Elies on 25.02.21.
//  Copyright © 2021 Christian Elies. All rights reserved.
//

import SwiftUI

protocol Node: Hashable, Identifiable {
    associatedtype V: View
    var children: [Self]? { get }
    var view: V { get }
}
