//
//  ViewState.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

enum ViewState<T: Hashable> {
    case loading
    case loaded(value: T)
    case failed(error: Swift.Error)
}
