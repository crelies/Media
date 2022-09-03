//
//  BrowserResult.swift
//  MediaCore
//
//  Created by Christian Elies on 03.05.21.
//

import Foundation

/// Represents the result of a media browser view.
public enum BrowserResult<T: Hashable, U: Hashable> {
    /// The result is a concrete media type, like `LivePhoto`, `Photo` or `Video`.
    case media(_ value: T, itemProvider: NSItemProvider?)
    /// The result is a data representation, like `URL` or `Data`.
    case data(_ data: U)
}
