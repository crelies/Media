//
//  Extensions.swift
//  Media-Example
//
//  Created by Christian Elies on 23.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Foundation
import MediaCore

extension Album: Identifiable {
    public var id: String { identifier ?? UUID().uuidString }
}

extension Audio: Identifiable {
    public var id: String { identifier?.localIdentifier ?? UUID().uuidString }
}

extension LivePhoto: Identifiable {
    public var id: String { identifier?.localIdentifier ?? UUID().uuidString }
}

extension Photo: Identifiable {
    public var id: String { identifier?.localIdentifier ?? UUID().uuidString }
}

extension Video: Identifiable {
    public var id: String { identifier?.localIdentifier ?? UUID().uuidString }
}
