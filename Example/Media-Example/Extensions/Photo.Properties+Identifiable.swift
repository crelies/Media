//
//  Photo.Properties+Identifiable.swift
//  Media-Example
//
//  Created by Christian Elies on 19/02/2023.
//  Copyright © 2023 Christian Elies. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import MediaCore

extension Photo.Properties: Identifiable {
    public var id: String { "\(exif.dateTimeOriginal ?? "")_\(UUID().uuidString)" }
}
#endif
