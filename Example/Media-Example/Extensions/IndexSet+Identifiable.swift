//
//  IndexSet+Identifiable.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

import Foundation

extension IndexSet: Identifiable {
    public var id: Self { self }
}
