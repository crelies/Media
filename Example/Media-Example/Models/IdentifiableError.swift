//
//  IdentifiableError.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

struct IdentifiableError {
    let error: Swift.Error
}

extension IdentifiableError: Identifiable {
    var id: String { error.localizedDescription }
}
